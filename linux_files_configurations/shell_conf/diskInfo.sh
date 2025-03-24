#! /bin/bash

disk="/dev/sda2" 
string_info=$(df -h | grep "$disk") # gets only the specific disk defined.
result=$(echo $string_info | grep -o "[0-9]%")  # gets only the number wih the '%' character.
echo "The disk '$disk' has $result of usage"
num_result=$(echo $result | grep -o "[0-9]")  # gets only the number wih the '%' character.
var=$(($num_result+4))
echo $var
