C_sorting : ./obj/Main.o ./obj/Functions.o
	gcc -o C_sorting ./obj/Main.o ./obj/Functions.o
    
./obj/Main.o : Main.c
	gcc -o ./obj/Main.o -c Main.c

./obj/Functions.o : Functions.c
	gcc -o ./obj/Functions.o -c Functions.c

clean : 
		rm ./obj/*.o C_sorting