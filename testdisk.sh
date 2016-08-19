#!/bin/dash

echo "Please write the mount point or directory. Example: /home"
read path
until [ -d $path ]; do 
	echo "Not is a directory"
	read path
done

echo "Is the mount point or directory in a local disk (Y/N)"
read prompt
while [ $prompt != "Y" -a $prompt != "N" ]
do
	echo "Please use Y for yes or N for No"
	read prompt
done

if [ "$prompt" = "Y" ]; then
	echo "Performing local disk test"
        for i in 1 2 3 4; do
                echo "Test Throughput (Streaming I/O) number $i"	
		dd if=/dev/zero of=$path/testfile bs=1G count=1 oflag=direct  
	done

	for i in 1 2 3 4; do
		echo "Test Latency number $i"
		dd if=/dev/zero of=$path/testfile bs=512 count=1000 oflag=direct
	done
else
	echo "Performing SAN disk test"
        for i in 1 2 3 4; do
                echo "Test Throughput (Streaming I/O) number $i"	
		dd if=/dev/zero of=$path/testfile bs=1G count=1 oflag=dsync
	done

	for i in 1 2 3 4; do
		echo "Test Latency number $i"
		dd if=/dev/zero of=$path/testfile bs=512 count=1000 oflag=dsync
	done
fi
