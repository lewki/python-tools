#!/usr/bin/python

from random import randint

secret = randint(1,100)

count = 0
while True:
    g = input('please input guess number(1..100):')
    count += 1
    guess = int(g)

    if guess > secret:
        print "too high"
    elif guess < secret:
        print "too low"
    else:
        print "you win"
        print secret
        print "you guess %d times" % count
        break
