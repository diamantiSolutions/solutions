cp db.properties.template  /tmp/db.prop.tmp
cd /tmp

if [ "${DB}" = "postgres" ]; then
   echo "db.driver=org.postgresql.Driver" >> db.prop.tmp
   echo "db.url=jdbc:postgresql://$target_ip:5432/ycsb"  >> db.prop.tmp
   echo "db.user=pgbench" >> db.prop.tmp
   echo "db.passwd=admin" >> db.prop.tmp
else
   echo "db.driver=com.mysql.jdbc.Driver" >> db.prop.tmp
   echo "db.url=jdbc:mysql://$target_ip:3306/ycsb"  >> db.prop.tmp
   echo "db.user=root" >> db.prop.tmp
   echo "db.passwd=admin" >> db.prop.tmp
fi

if [ "${DB}" = "memsql" ]; then
    sed -i -e '/passwd/d' db.prop.tmp
fi

cat db.prop.tmp
rm -rf db.prop.tmp
cd /usr/local/bin
