all : 
	gnatmake task4.adb

clean : *o *ali
	rm *.o *ali
