#! /bin/sh
mkdir -p $1/home/mar/$2
yes | cp $2/src/mar/action.hoon $1/home/mar/$2
yes | cp $2/src/sur/$2.hoon $1/home/sur
yes | cp $2/src/app/$2.hoon $1/home/app