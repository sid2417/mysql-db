#!/bin/bash/

#colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#Date #ScriptName #Logfile
TIME_STAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo "$?" | cut -d "." -f1)
LOG_FILE=$SCRIPT_NAME+$TIME_STAMP.log

#UserId
USER_ID=$(id -u)
if [ USER_ID -ne 0 ]
then 
    echo -e "$R Please Provide SUDO access...$N"
    exit 1
else    
    echo -e "$G You are a Super user $N"
fi


VALIDATE ()
{
    if ($1 -ne 0)
    then 
        echo -e "$R $2 FAILURE $N"
        exit 1
    else    
        echo -e "$G $2 SUCCESS $N"
    fi
}


dnf module disable nodejs -y &>>LOG_FILE
VALIDATE $? "Disabling nodejs previous version : "

dnf module enable nodejs:20 -y &>>LOG_FILE
VALIDATE $? "Enabling nodejs required version : "

dnf install nodejs -y &>>LOG_FILE
VALIDATE $? "Installing nodejs : "

useradd expense
VALIDATE $? "Adding user : "

mkdir /app
VALIDATE $? "Creating /app folder"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOG_FILE
VALIDATE $? "Downloading backend.zip software in tmp folder : "

cd /app
VALIDATE $? "Entered into the /app folder : "

unzip /tmp/backend.zip &>>LOG_FILE
VALIDATE $? "unzipping backend software in /app folder : "

npm install &>>LOG_FILE
VALIDATE $? "Installing required Dependencies"



vim /etc/systemd/system/backend.service
cp 



systemctl daemon-reload &>>LOG_FILE
VALIDATE $? "Deamon Reloading : "

systemctl start backend &>>LOG_FILE
VALIDATE $? "Starting Backend application : "

systemctl enable backend
VALIDATE $? "Enablind Backend application : "

dnf install mysql -y &>>LOG_FILE
VALIDATE $? "Installing mysql to connect the backend server : "

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>LOG_FILE
VALIDATE $? "Setting up password to the mySQL : "

systemctl restart backend &>>LOG_FILE
VALIDATE $? "Restarting the Backend Application : "

echo -e "$Y Backend installation is Going GOOD $N" &>>LOG_FILE