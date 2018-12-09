#!/bin/bash
#===============================================================================
#  Program name:  calculator_game.sh 
#   DESCRIPTION:  This is a calculator game. 
# 
#  REQUIREMENTS:  Good memory
#          BUGS:  System message "Terminated" at the very end of the program
#         NOTES:  
#        AUTHOR:  Olga Makarova 
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  11/01/2018 10:37:37 PM PST
#      REVISION:  1.0
#===============================================================================

#Function setTitle introduces the game.
setTitle() {
echo -e Hello, this game checks your knowledge of the multiplication table.
}


#The setTitle function is called
setTitle -e

# The setSpeed function allows the user to set the speed of the game.
#There is a case statement inside the setSpeed function,
# which adds a humurous comment based on the user's choice of speed. 
setSpeed(){
echo -e Please choose your speed in seconds. Options: 20, 30, 40: `echo $'\n  '` 
 
read speed

case $speed in
    20)
    echo -e Gutsy! '\n'
    ;;
    30)
    echo -e That is safe! '\n'
    ;;
    40)
    echo -e Turtle!'\n'
    ;;
    *)
    echo -e Pay attention! '\n'
    ;;
    esac
}

#The setSpeed function is called
setSpeed


#Conditional until-loop. If the user's chosen speed is not one of the preset 
#speeds, the function setSpeed will keep prompting for setting the speed 
until [[ $speed -eq 20 ]] || [[ $speed -eq 30 ]] || [[ $speed -eq 40 ]]
do 
setSpeed
done


#variable "s" is the time remaining in the game. 
#It is initially set to 1 so that s > 0
s=1

#This is the setStopwatch function. There is a while-loop inside. 
#The function calculates the time left for the game:
#Time left = the speed set by the user minus (current time minus game start).
#The loop counts down, performing the equation each iteration, until s equals 0.
#When s is equal to 0 the trap command is executed, stopping the game
setStopwatch(){
while [[ s -gt 0 ]]
do
s="$((speed - (SECONDS - start)))"
echo -e "seconds left: $s"
sleep 0 
done
trap "kill 0  " EXIT
exit 0
}

let questions=10
let counter=0
let wrong_attempts=0

echo "Let's start!"
start="$SECONDS"

#This is the main while-loop (WHILE_LOOP_1).
#The game continues while the counter indicates fewer than 10 questions 
#With every attempt the counter increases by 1 
while [[ $counter -le  $questions ]] 
do

#generation of two random numbers, A and B
A=$((RANDOM%11))
B=$((RANDOM%11))
#Variable Z is the correct answer
Z=A*B

#The program asks the user to multiply random number A by random number B
echo -e "$A x $B = "

#The program reads user's input
read input

#The setStopwatch program is called, starting the timer. 
#The results of setStopwatch are written to a time_output.txt file

setStopwatch > time_output.txt 2>&1 &

#If-statement. If user's input equals variable Z (the correct answer),
#The program echos "That is correct!", echos the time left, 
#goes to the very end of the script, increases the counter by 1 
#and presents a new problem 
  if [[ input -eq Z ]]
  then 
  echo -e "\rThat is correct!"

#New variable "output" is introduced. i
#"output" is read from the last line of the time_output.txt file.
  output=`tail -n 1 time_output.txt| cat`

#After each successful answer, the program echos time left from the time_output.txt file
  echo -e "$output"
  counter=$((counter+1))

#If the user's answer is incorrect...
  elif [[ input -ne Z ]] 
  then


#... then the program starts another while-loop, WHILE_LOOP_2
# while the answer does not equal "Z", the correct answer, 
#the program counts the number of wrong attempts.
             while [[ input -ne Z ]]
             do
             wrong_attempts=$((wrong_attempts+1))

# If there are more than 4 wrong attempts the game is over.
                 if [[ wrong_attempts -gt 4 ]]
                    then
                    echo "Too many incorrect answers." 
                    echo "Learn the damn multiplication table!"
#The program exits if the previous command executed successfully
                    exit 0                    

#Else, if the number of attempts is less than 4, then the program prompts the user to try harder!
                 else
                 echo -e "Wrong answer. Try harder!"
                 output=`tail -n 1 time_output.txt| cat`
                 echo -e "$output"
                 echo $A x $B = 
                 read input
                 fi
#End of WHILE_LOOP_2. The user gave a correct answer equalling "Z".
             done

#The program zeros the number of wrong attempts until the next question 
             wrong_attempts=0
             echo That is correct. Thank you!
             output=`tail -n 1 time_output.txt| cat`
             echo -e "$output"
  fi 
#The counter increases by 1 after each correct answer in the main loop (WHILE_LOOP_1).
counter=$((counter+1))

#End of WHILE_LOOP_1. The user gave correct answers within the limits of time and questions. 
done
echo "Next level!"

