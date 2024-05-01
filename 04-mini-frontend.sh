#!/bin/bash/

#colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#Date #ScriptName #Logfile
TIME_STAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo "$?" | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME+$TIME_STAMP.log

#UserId
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]
then 
    echo -e "$R Please Provide SUDO access...$N"
    exit 1
else    
    echo -e "$G You are a Super user $N"
fi


VALIDATE ()
{
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 FAILURE $N"
        exit 1
    else    
        echo -e "$G $2 SUCCESS $N"
    fi
}


dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installind nginx : "

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enabling nginx : "

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Starting the nginx : "

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing Default content of nginx : "

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading Frontend application in /tmp folder : "

cd /usr/share/nginx/html &>>$LOG_FILE

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "Unzipping the frontend application : "

#vim /etc/nginx/default.d/expense.conf
cp /home/ec2-user/mysql-db/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Congiguration of Frontend to Backend connection is : "

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "Restarting the nginx : "

echo -e "$Y Frontend installation is Going GOOD $N" 