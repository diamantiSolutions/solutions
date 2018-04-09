package nginx

import (
	"bytes"
	"fmt"
	"strings"

	"github.com/golang/glog"
	"github.com/nginxinc/kubernetes-ingress/nginx-controller/nginx/plus"
	meta_v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	api_v1 "k8s.io/client-go/pkg/api/v1"
	extensions "k8s.io/client-go/pkg/apis/extensions/v1beta1"
)

const emptyHost = ""
const DefaultServerPemName = "default"

// Configurator transforms an Ingress resource into NGINX Configuration
type Configurator struct {
	nginx    *NginxController
	config   *Config
	nginxAPI *plus.NginxAPIController
}

// NewConfigurator creates a new Configurator
func NewConfigurator(nginx *NginxController, config *Config, nginxAPI *plus.NginxAPIController) *Configurator {
	cnf := Configurator{
		nginx:    nginx,
		config:   config,
		nginxAPI: nginxAPI,
	}

	return &cnf
}

func (cnf *Configurator) AddOrUpdateDHParam(content string) (string, error) {
	return cnf.nginx.AddOrUpdateDHParam(content)
}

// AddOrUpdateIngress adds or updates NGINX configuration for the Ingress resource
func (cnf *Configurator) AddOrUpdateIngress(ingEx *IngressEx) error {
	cnf.addOrUpdateIngress(ingEx)

	if err := cnf.nginx.Reload(); err != nil {
		return fmt.Errorf("Error when adding or updating ingress %v/%v: %v", ingEx.Ingress.Namespace, ingEx.Ingress.Name, err)
	}
	return nil
}

func (cnf *Configurator) addOrUpdateIngress(ingEx *IngressEx) {
	pems := cnf.updateCertificates(ingEx)
	nginxCfg := cnf.generateNginxCfg(ingEx, pems)
	name := objectMetaToFileName(&ingEx.Ingress.ObjectMeta)
	cnf.nginx.AddOrUpdateIngress(name, nginxCfg)
}

func (cnf *Configurator) updateCertificates(ingEx *IngressEx) map[string]string {
	pems := make(map[string]string)

	for _, tls := range ingEx.Ingress.Spec.TLS {
		secretName := tls.SecretName

		pemFileName := cnf.addOrUpdateTLSSecret(ingEx.Secrets[secretName])

		for _, host := range tls.Hosts {
			pems[host] = pemFileName
		}
		if len(tls.Hosts) == 0 {
			pems[emptyHost] = pemFileName
		}
	}

	return pems
}
func (cnf *Configurator) generateNginxCfg(ingEx *IngressEx, pems map[string]string) IngressNginxConfig {
	ingCfg := cnf.createConfig(ingEx)

	upstreams := make(map[string]Upstream)

	wsServices := getWebsocketServices(ingEx)
	spServices := getSessionPersistenceServices(ingEx)
	rewrites := getRewrites(ingEx)
	sslServices := getSSLServices(ingEx)

	if ingEx.Ingress.Spec.Backend != nil {
		name := getNameForUpstream(ingEx.Ingress, emptyHost, ingEx.Ingress.Spec.Backend.ServiceName)
		upstream := cnf.createUpstream(ingEx, name, ingEx.Ingress.Spec.Backend, ingEx.Ingress.Namespace, spServices[ingEx.Ingress.Spec.Backend.ServiceName], ingCfg.LBMethod)
		upstreams[name] = upstream
	}

	var servers []Server

	for _, rule := range ingEx.Ingress.Spec.Rules {
		if rule.IngressRuleValue.HTTP == nil {
			continue
		}

		serverName := rule.Host

		statuzZone := rule.Host

		server := Server{
			Name:                  serverName,
			ServerTokens:          ingCfg.ServerTokens,
			HTTP2:                 ingCfg.HTTP2,
			RedirectToHTTPS:       ingCfg.RedirectToHTTPS,
			ProxyProtocol:         ingCfg.ProxyProtocol,
			HSTS:                  ingCfg.HSTS,
			HSTSMaxAge:            ingCfg.HSTSMaxAge,
			HSTSIncludeSubdomains: ingCfg.HSTSIncludeSubdomains,
			StatusZone:            statuzZone,
			RealIPHeader:          ingCfg.RealIPHeader,
			SetRealIPFrom:         ingCfg.SetRealIPFrom,
			RealIPRecursive:       ingCfg.RealIPRecursive,
			ProxyHideHeaders:      ingCfg.ProxyHideHeaders,
			ProxyPassHeaders:      ingCfg.ProxyPassHeaders,
			ServerSnippets:        ingCfg.ServerSnippets,
		}

		if pemFile, ok := pems[serverName]; ok {
			server.SSL = true
			server.SSLCertificate = pemFile
			server.SSLCertificateKey = pemFile
		}

		var locations []Location
		rootLocation := false

		for _, path := range rule.HTTP.Paths {
			upsName := getNameForUpstream(ingEx.Ingress, rule.Host, path.Backend.ServiceName)

			if _, exists := upstreams[upsName]; !exists {
				upstream := cnf.createUpstream(ingEx, upsName, &path.Backend, ingEx.Ingress.Namespace, spServices[path.Backend.ServiceName], ingCfg.LBMethod)
				upstreams[upsName] = upstream
			}

			loc := createLocation(pathOrDefault(path.Path), upstreams[upsName], &ingCfg, wsServices[path.Backend.ServiceName], rewrites[path.Backend.ServiceName], sslServices[path.Backend.ServiceName])
			locations = append(locations, loc)

			if loc.Path == "/" {
				rootLocation = true
			}
		}

		if rootLocation == false && ingEx.Ingress.Spec.Backend != nil {
			upsName := getNameForUpstream(ingEx.Ingress, emptyHost, ingEx.Ingress.Spec.Backend.ServiceName)
			loc := createLocation(pathOrDefault("/"), upstreams[upsName], &ingCfg, wsServices[ingEx.Ingress.Spec.Backend.ServiceName], rewrites[ingEx.Ingress.Spec.Backend.ServiceName], sslServices[ingEx.Ingress.Spec.Backend.ServiceName])
			locations = append(locations, loc)
		}

		server.Locations = locations
		servers = append(servers, server)
	}

	return IngressNginxConfig{Upstreams: upstreamMapToSlice(upstreams), Servers: servers}
}

func (cnf *Configurator) createConfig(ingEx *IngressEx) Config {
	ingCfg := *cnf.config

	//Override from annotation
	if lbMethod, exists := ingEx.Ingress.Annotations["nginx.org/lb-method"]; exists {
		ingCfg.LBMethod = lbMethod
	}

	if serverTokens, exists, err := GetMapKeyAsBool(ingEx.Ingress.Annotations, "nginx.org/server-tokens", ingEx.Ingress); exists {
		if err != nil {
			if cnf.isPlus() {
				ingCfg.ServerTokens = ingEx.Ingress.Annotations["nginx.org/server-tokens"]
			} else {
				glog.Error(err)
			}
		} else {
			ingCfg.ServerTokens = "off"
			if serverTokens {
				ingCfg.ServerTokens = "on"
			}
		}
	}

	if serverSnippets, exists, err := GetMapKeyAsStringSlice(ingEx.Ingress.Annotations, "nginx.org/server-snippets", ingEx.Ingress, "\n"); exists {
		if err != nil {
			glog.Error(err)
		} else {
			ingCfg.ServerSnippets = serverSnippets
		}
	}
	if locationSnippets, exists, err := GetMapKeyAsStringSlice(ingEx.Ingress.Annotations, "nginx.org/location-snippets", ingEx.Ingress, "\n"); exists {
		if err != nil {
			glog.Error(err)
		} else {
			ingCfg.LocationSnippets = locationSnippets
		}
	}

	if proxyConnectTimeout, exists := ingEx.Ingress.Annotations["nginx.org/proxy-connect-timeout"]; exists {
		ingCfg.ProxyConnectTimeout = proxyConnectTimeout
	}
	if proxyReadTimeout, exists := ingEx.Ingress.Annotations["nginx.org/proxy-read-timeout"]; exists {
		ingCfg.ProxyReadTimeout = proxyReadTimeout
	}
	if proxyHideHeaders, exists, err := GetMapKeyAsStringSlice(ingEx.Ingress.Annotations, "nginx.org/proxy-hide-headers", ingEx.Ingress, ","); exists {
		if err != nil {
			glog.Error(err)
		} else {
			ingCfg.ProxyHideHeaders = proxyHideHeaders
		}
	}
	if proxyPassHeaders, exists, err := GetMapKeyAsStringSlice(ingEx.Ingress.Annotations, "nginx.org/proxy-pass-headers", ingEx.Ingress, ","); exists {
		if err != nil {
			glog.Error(err)
		} else {
			ingCfg.ProxyPassHeaders = proxyPassHeaders
		}
	}
	if clientMaxBodySize, exists := ingEx.Ingress.Annotations["nginx.org/client-max-body-size"]; exists {
		ingCfg.ClientMaxBodySize = clientMaxBodySize
	}
	if redirectToHTTPS, exists, err := GetMapKeyAsBool(ingEx.Ingress.Annotations, "nginx.org/redirect-to-https", ingEx.Ingress); exists {
		if err != nil {
			glog.Error(err)
		} else {
			ingCfg.RedirectToHTTPS = redirectToHTTPS
		}
	}
	if proxyBuffering, exists, err := GetMapKeyAsBool(ingEx.Ingress.Annotations, "nginx.org/proxy-buffering", ingEx.Ingress); exists {
		if err != nil {
			glog.Error(err)
		} else {
			ingCfg.ProxyBuffering = proxyBuffering
		}
	}

	if hsts, exists, err := GetMapKeyAsBool(ingEx.Ingress.Annotations, "nginx.org/hsts", ingEx.Ingress); exists {
		if err != nil {
			glog.Error(err)
		} else {
			parsingErrors := false

			hstsMaxAge, existsMA, err := GetMapKeyAsInt(ingEx.Ingress.Annotations, "nginx.org/hsts-max-age", ingEx.Ingress)
			if existsMA && err != nil {
				glog.Error(err)
				parsingErrors = true
			}
			hstsIncludeSubdomains, existsIS, err := GetMapKeyAsBool(ingEx.Ingress.Annotations, "nginx.org/hsts-include-subdomains", ingEx.Ingress)
			if existsIS && err != nil {
				glog.Error(err)
				parsingErrors = true
			}

			if parsingErrors {
				glog.Errorf("Ingress %s/%s: There are configuration issues with hsts annotations, skipping annotions for all hsts settings", ingEx.Ingress.GetNamespace(), ingEx.Ingress.GetName())
			} else {
				ingCfg.HSTS = hsts
				if existsMA {
					ingCfg.HSTSMaxAge = hstsMaxAge
				}
				if existsIS {
					ingCfg.HSTSIncludeSubdomains = hstsIncludeSubdomains
				}
			}
		}
	}

	if proxyBuffers, exists := ingEx.Ingress.Annotations["nginx.org/proxy-buffers"]; exists {
		ingCfg.ProxyBuffers = proxyBuffers
	}
	if proxyBufferSize, exists := ingEx.Ingress.Annotations["nginx.org/proxy-buffer-size"]; exists {
		ingCfg.ProxyBufferSize = proxyBufferSize
	}
	if proxyMaxTempFileSize, exists := ingEx.Ingress.Annotations["nginx.org/proxy-max-temp-file-size"]; exists {
		ingCfg.ProxyMaxTempFileSize = proxyMaxTempFileSize
	}
	return ingCfg
}

func getWebsocketServices(ingEx *IngressEx) map[string]bool {
	wsServices := make(map[string]bool)

	if services, exists := ingEx.Ingress.Annotations["nginx.org/websocket-services"]; exists {
		for _, svc := range strings.Split(services, ",") {
			wsServices[svc] = true
		}
	}

	return wsServices
}

func getRewrites(ingEx *IngressEx) map[string]string {
	rewrites := make(map[string]string)

	if services, exists := ingEx.Ingress.Annotations["nginx.org/rewrites"]; exists {
		for _, svc := range strings.Split(services, ";") {
			if serviceName, rewrite, err := parseRewrites(svc); err != nil {
				glog.Errorf("In %v nginx.org/rewrites contains invalid declaration: %v, ignoring", ingEx.Ingress.Name, err)
			} else {
				rewrites[serviceName] = rewrite
			}
		}
	}

	return rewrites
}

func parseRewrites(service string) (serviceName string, rewrite string, err error) {
	parts := strings.SplitN(service, " ", 2)

	if len(parts) != 2 {
		return "", "", fmt.Errorf("Invalid rewrite format: %s\n", service)
	}

	svcNameParts := strings.Split(parts[0], "=")
	if len(svcNameParts) != 2 {
		return "", "", fmt.Errorf("Invalid rewrite format: %s\n", svcNameParts)
	}

	rwPathParts := strings.Split(parts[1], "=")
	if len(rwPathParts) != 2 {
		return "", "", fmt.Errorf("Invalid rewrite format: %s\n", rwPathParts)
	}

	return svcNameParts[1], rwPathParts[1], nil
}

func getSSLServices(ingEx *IngressEx) map[string]bool {
	sslServices := make(map[string]bool)

	if services, exists := ingEx.Ingress.Annotations["nginx.org/ssl-services"]; exists {
		for _, svc := range strings.Split(services, ",") {
			sslServices[svc] = true
		}
	}

	return sslServices
}

func getSessionPersistenceServices(ingEx *IngressEx) map[string]string {
	spServices := make(map[string]string)

	if services, exists := ingEx.Ingress.Annotations["nginx.com/sticky-cookie-services"]; exists {
		for _, svc := range strings.Split(services, ";") {
			if serviceName, sticky, err := parseStickyService(svc); err != nil {
				glog.Errorf("In %v nginx.com/sticky-cookie-services contains invalid declaration: %v, ignoring", ingEx.Ingress.Name, err)
			} else {
				spServices[serviceName] = sticky
			}
		}
	}

	return spServices
}

func parseStickyService(service string) (serviceName string, stickyCookie string, err error) {
	parts := strings.SplitN(service, " ", 2)

	if len(parts) != 2 {
		return "", "", fmt.Errorf("Invalid sticky-cookie service format: %s\n", service)
	}

	svcNameParts := strings.Split(parts[0], "=")
	if len(svcNameParts) != 2 {
		return "", "", fmt.Errorf("Invalid sticky-cookie service format: %s\n", svcNameParts)
	}

	return svcNameParts[1], parts[1], nil
}

func createLocation(path string, upstream Upstream, cfg *Config, websocket bool, rewrite string, ssl bool) Location {
	loc := Location{
		Path:                 path,
		Upstream:             upstream,
		ProxyConnectTimeout:  cfg.ProxyConnectTimeout,
		ProxyReadTimeout:     cfg.ProxyReadTimeout,
		ClientMaxBodySize:    cfg.ClientMaxBodySize,
		Websocket:            websocket,
		Rewrite:              rewrite,
		SSL:                  ssl,
		ProxyBuffering:       cfg.ProxyBuffering,
		ProxyBuffers:         cfg.ProxyBuffers,
		ProxyBufferSize:      cfg.ProxyBufferSize,
		ProxyMaxTempFileSize: cfg.ProxyMaxTempFileSize,
		LocationSnippets:     cfg.LocationSnippets,
	}

	return loc
}

func (cnf *Configurator) createUpstream(ingEx *IngressEx, name string, backend *extensions.IngressBackend, namespace string, stickyCookie string, lbMethod string) Upstream {
	var ups Upstream

	if cnf.isPlus() {
		ups = Upstream{Name: name, StickyCookie: stickyCookie}
	} else {
		ups = NewUpstreamWithDefaultServer(name)
	}

	endps, exists := ingEx.Endpoints[backend.ServiceName+backend.ServicePort.String()]
	if exists {
		var upsServers []UpstreamServer
		for _, endp := range endps {
			addressport := strings.Split(endp, ":")
			upsServers = append(upsServers, UpstreamServer{addressport[0], addressport[1]})
		}
		if len(upsServers) > 0 {
			ups.UpstreamServers = upsServers
		}
	}
	ups.LBMethod = lbMethod
	return ups
}

func pathOrDefault(path string) string {
	if path == "" {
		return "/"
	}
	return path
}

func getNameForUpstream(ing *extensions.Ingress, host string, service string) string {
	return fmt.Sprintf("%v-%v-%v-%v", ing.Namespace, ing.Name, host, service)
}

func upstreamMapToSlice(upstreams map[string]Upstream) []Upstream {
	result := make([]Upstream, 0, len(upstreams))

	for _, ups := range upstreams {
		result = append(result, ups)
	}

	return result
}

// AddOrUpdateTLSSecret creates or updates a file with the content of the TLS secret
func (cnf *Configurator) AddOrUpdateTLSSecret(secret *api_v1.Secret, reload bool) error {
	cnf.addOrUpdateTLSSecret(secret)

	if !reload {
		return nil
	}

	if err := cnf.nginx.Reload(); err != nil {
		return fmt.Errorf("Error when reloading NGINX when updating Secret: %v", err)
	}
	return nil
}

func (cnf *Configurator) addOrUpdateTLSSecret(secret *api_v1.Secret) string {
	name := objectMetaToFileName(&secret.ObjectMeta)
	data := GenerateCertAndKeyFileContent(secret)
	return cnf.nginx.AddOrUpdatePemFile(name, data)
}

func (cnf *Configurator) AddOrUpdateDefaultServerTLSSecret(secret *api_v1.Secret) error {
	data := GenerateCertAndKeyFileContent(secret)
	cnf.nginx.AddOrUpdatePemFile(DefaultServerPemName, data)

	if err := cnf.nginx.Reload(); err != nil {
		return fmt.Errorf("Error when reloading NGINX when updating the default server Secret: %v", err)
	}
	return nil
}

// GenerateCertAndKeyFileContent generates a pem file content from the secret
func GenerateCertAndKeyFileContent(secret *api_v1.Secret) []byte {
	var res bytes.Buffer

	res.Write(secret.Data[api_v1.TLSCertKey])
	res.WriteString("\n")
	res.Write(secret.Data[api_v1.TLSPrivateKeyKey])

	return res.Bytes()
}

// DeleteTLSSecret deletes the file associated with the TLS secret and the configuration files for the Ingress resources. NGINX is reloaded only when len(ings) > 0
func (cnf *Configurator) DeleteTLSSecret(key string, ings []extensions.Ingress) error {
	for _, ing := range ings {
		cnf.nginx.DeleteIngress(objectMetaToFileName(&ing.ObjectMeta))
	}

	cnf.nginx.DeletePemFile(keyToFileName(key))

	if len(ings) > 0 {
		if err := cnf.nginx.Reload(); err != nil {
			return fmt.Errorf("Error when reloading NGINX when deleting Secret %v: %v", key, err)
		}
	}

	return nil
}

// DeleteIngress deletes NGINX configuration for the Ingress resource
func (cnf *Configurator) DeleteIngress(key string) error {
	cnf.nginx.DeleteIngress(keyToFileName(key))
	if err := cnf.nginx.Reload(); err != nil {
		return fmt.Errorf("Error when removing ingress %v: %v", key, err)
	}
	return nil
}

// UpdateEndpoints updates endpoints in NGINX configuration for the Ingress resource
func (cnf *Configurator) UpdateEndpoints(ingEx *IngressEx) error {
	cnf.addOrUpdateIngress(ingEx)

	if cnf.isPlus() {
		cnf.updatePlusEndpoints(ingEx)
	} else {
		if err := cnf.nginx.Reload(); err != nil {
			return fmt.Errorf("Error reloading NGINX when updating endpoints for %v/%v: %v", ingEx.Ingress.Namespace, ingEx.Ingress.Name, err)
		}
	}
	return nil
}

func (cnf *Configurator) updatePlusEndpoints(ingEx *IngressEx) {
	if ingEx.Ingress.Spec.Backend != nil {
		name := getNameForUpstream(ingEx.Ingress, emptyHost, ingEx.Ingress.Spec.Backend.ServiceName)
		endps, exists := ingEx.Endpoints[ingEx.Ingress.Spec.Backend.ServiceName+ingEx.Ingress.Spec.Backend.ServicePort.String()]
		if exists {
			err := cnf.nginxAPI.UpdateServers(name, endps)
			if err != nil {
				glog.Warningf("Couldn't update the endponts for %v: %v", name, err)
			}
		}
	}
	for _, rule := range ingEx.Ingress.Spec.Rules {
		if rule.IngressRuleValue.HTTP == nil {
			continue
		}
		for _, path := range rule.HTTP.Paths {
			name := getNameForUpstream(ingEx.Ingress, rule.Host, path.Backend.ServiceName)
			endps, exists := ingEx.Endpoints[path.Backend.ServiceName+path.Backend.ServicePort.String()]
			if exists {
				err := cnf.nginxAPI.UpdateServers(name, endps)
				if err != nil {
					glog.Warningf("Couldn't update the endponts for %v: %v", name, err)
				}
			}
		}
	}
}

// UpdateConfig updates NGINX Configuration parameters
func (cnf *Configurator) UpdateConfig(config *Config, ingExes []*IngressEx) error {
	cnf.config = config
	mainCfg := &NginxMainConfig{
		HTTPSnippets:              config.MainHTTPSnippets,
		ServerNamesHashBucketSize: config.MainServerNamesHashBucketSize,
		ServerNamesHashMaxSize:    config.MainServerNamesHashMaxSize,
		LogFormat:                 config.MainLogFormat,
		SSLProtocols:              config.MainServerSSLProtocols,
		SSLCiphers:                config.MainServerSSLCiphers,
		SSLDHParam:                config.MainServerSSLDHParam,
		SSLPreferServerCiphers:    config.MainServerSSLPreferServerCiphers,
		HTTP2:         config.HTTP2,
		ServerTokens:  config.ServerTokens,
		ProxyProtocol: config.ProxyProtocol,
	}

	cnf.nginx.UpdateMainConfigFile(mainCfg)

	for _, ingEx := range ingExes {
		cnf.addOrUpdateIngress(ingEx)
	}

	if err := cnf.nginx.Reload(); err != nil {
		return fmt.Errorf("Error when updating config from ConfigMap: %v", err)
	}

	return nil
}

func (cnf *Configurator) isPlus() bool {
	return cnf.nginxAPI != nil
}

func keyToFileName(key string) string {
	return strings.Replace(key, "/", "-", -1)
}

func objectMetaToFileName(meta *meta_v1.ObjectMeta) string {
	return meta.Namespace + "-" + meta.Name
}
