#!/bin/bash
read -p "Insert your Git Comment:" gitcomment
git add .
git commit -m "$gitcomment"
git push
