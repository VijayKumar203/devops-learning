#!/bin/bash

echo "Enter a number:"
read NUMBER

if (($NUMBER % 2) == 0); then
    echo "Given number $NUMBER is Even"
else
    echo "Given number $NUMBER is Odd"
fi

# Another Method
if ((($NUMBER % 2) == 0)); then
    echo "Given number $NUMBER is Even"
else
    echo "Given number $NUMBER is Odd"
fi

# Another Method
if [ $(($NUMBER % 2)) -eq 0 ]; then
    echo "Given number $NUMBER is Even"
else
    echo "Given number $NUMBER is Odd"
fi
