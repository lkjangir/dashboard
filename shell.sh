

#file=$1
location=$1
file=${location}/final.json

templates=$(ls ${location}/*.template)

echo $file > /tmp/f.txt
echo $location >> /tmp/f.txt

echo '{ "widgets": [ ' > $file

for template in $templates
do
	tmpl=$(cat ${template})
	echo ${tmpl%%+([[:space:]])} >> $file
	echo "," >> $file
done

sed -i '$ s/.$//' $file

echo "] }" >> $file


