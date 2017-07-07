/**
 * Created by ciprian on 7/7/17.
 */


const child = require('child_process');

child.execSync(" authbind --deep nohup /usr/bin/haraka -c /home/plusprivacy/Workspace/PlusPrivacy/servers/emailServer/ > /home/plusprivacy/Workspace/harakalogs.log &");