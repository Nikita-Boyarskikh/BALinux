#!/bin/bash

        $(df -ahi>/tmp/sysinfo/df-ahi & df -ah>/tmp/sysinfo/df-ah)

echo "Content-Type: text/html"
echo

to_html() {
    cat | sed -e 's/</\&lt/g; s/>/\&gt/g' | cat
}

STYLE="body {}
       table { border-collapse: collapse}
       td { border: solid black 1px }
       h1 { margin: 1px }
       .netstat { text-align: center }"

LoadAvg1=$(perl -e '`uptime` =~ /(\d+[\,|\.]\d+).*(\d+[\,\.]\d+).*(\d+[\,\.]\d+)/;
                   print "$1"' | sed -e's/\,/./')

LoadAvg2=$(perl -e '`uptime` =~ /(\d+[\,|\.]\d+).*(\d+[\,\.]\d+).*(\d+[\,\.]\d+)/;
                   print "$2"' | sed -e's/\,/./')

LoadAvg3=$(perl -e '`uptime` =~ /(\d+[\,|\.]\d+).*(\d+[\,\.]\d+).*(\d+[\,\.]\d+)/;
                   print "$3"' | sed -e's/\,/./')

Cores=$(cat /proc/cpuinfo | grep -c 'core id')

logs=$(ls -ult /var/www/sysinfo/history | tail -n+2 | to_html | \
       awk '{print "<tr><td>"$6" "$7" "$8"</td><td><a href=\"/sysinfo/history/"$9"\">"$9"</a></td></tr>"}'
      )

if [ $(echo "($LoadAvg1 > $Cores) || ($LoadAvg1 < 0.1*$Cores)" | bc) ]
then
    STYLE="$STYLE
           .loadavg1 { background-color:red !important}"
elif [ $(echo "(($LoadAvg1 + 0.3) > $Cores) || ($LoadAvg1 < 0.3*$Cores)" | bc) ]
then
    STYLE="$STYLE
           .loadavg1 { background-color:orange }"
fi

if [ $(echo "($LoadAvg2 > $Cores) || ($LoadAvg2 < 0.1*$Cores)" | bc) ]
then
    STYLE="$STYLE
           .loadavg2 { background-color:red !important}"
elif [ $(echo "(($LoadAvg2 + 0.3) > $Cores) || ($LoadAvg2 < 0.3*$Cores)" | bc) ]
then
    STYLE="$STYLE
           .loadavg2 { background-color:orange }"
fi

if [ $(echo "($LoadAvg3 > $Cores) || ($LoadAvg3 < 0.1*$Cores)" | bc) ]
then
    STYLE="$STYLE
           .loadavg3 { background-color:red !important}"
elif [ $(echo "(($LoadAvg3 + 0.3) > $Cores) || ($LoadAvg3 < 0.3*$Cores)" | bc) ]
then
    STYLE="$STYLE
           .loadavg3 { background-color:orange }"
fi

net() {
    netstat -ant | grep -c $1
}

cat <<HTML

<!DOCTYPE html>
<html>
<head>
    <style type='text/css'>
        $STYLE
    </style>
    <title>Sysinfo</title>
    <meta charset='utf-8'>
</head>
<body>
    <center><h1>Добро пожаловать в Sysinfo!</h1></center>
    <p>Вы вошли с адреса: $HTTP_X_FORWARDED_FOR:$HTTP_X_FORWARDED_FOR_PORT</p>
    <p>О перенаправлении Вас на локальный порт 8888 позаботился Nginx версии $HTTP_X_NGX_VERSION</p>
    <p>Его внешний адрес: $REMOTE_ADDR:$REMOTE_PORT</p>

    <hr>
    <p><h1>Load Average:</h1> (Ядер в системе: <b>$Cores</b>)</p>
    <table class="loadavg"><tbody>
    <tr><td>За последнюю минуту</td>
        <td>За последние 5 минут</td>
        <td>За последние 10 минут</td>
    </tr>
    <tr style="text-align: center"><td class="loadavg1"><b>$LoadAvg1</b></td>
        <td class="loadavg2"><b>$LoadAvg2</b></td>
        <td class="loadavg3"><b>$LoadAvg3</b></td>
    </tr>
    </table></tbody>

    <hr>
    <h1>Загрузка дисков</h1>
    <table class="iostat"><tbody>
        $(iostat -xp | tail -n+6 | head -n-1 | to_html | awk '{print "<tr><td>", $1, "</td><td>", $4, "</td><td>", $5, "</td><td>", $10, "</td><td>", $14, "</td></tr>"}')
    </tbody></table>

    <hr>
    <h1>Загрузка сети</h1>
    <table class="procfs"><tbody>
    <tr><td rowspan=2>Inter-
                      face</td><td rowspan=2></td><td colspan=8 align="center">Receive</td><td></td><td colspan=8 align="center">Transmit</td></tr>
    <tr><td>bytes</td><td>packets</td><td>errs</td><td>drop</td><td>fifo</td><td>frame</td><td>compressed</td><td>multicast</td><td></td>
        <td>bytes</td><td>packets</td><td>errs</td><td>drop</td><td>fifo</td><td>colls</td><td>carrier</td><td>compressed</td></tr>
    $(cat /proc/net/dev | tail -n+3 | to_html | awk '{print "<tr><td>", $1, "</td><td></td><td>", $2, "</td><td>", $3, "</td><td>", $4, "</td><td>", $5, "</td><td>", $6, "</td><td>", $7, "</td><td>", $8, "</td><td>", $9, "</td><td></td><td>", $10, "</td><td>", $11, "</td><td>", $12, "</td><td>", $13, "</td><td>", $14, "</td><td>", $15, "</td><td>", $16, "</td><td>", $17, "</td></tr>"}')
    </tbody></table>

    <hr>
    <h1>Top talkers</h1>
    
    tcpdump

    <hr>
    <h1>Информация о сетевых соединениях</h1>
    <h3>Слушающие сокеты:</h3>
    <table class="sockets"><tbody>
    <tr><td rowspan=6>TCP</td><td>Протокол</td><td>$(netstat | grep STREAM | awk '{print "</td><td>", $1}')</td></tr>
    <tr><td>Кол-во ссылок</td><td>$(netstat | grep STREAM | awk '{print "</td><td>", $2}')</td></tr>
    <tr><td>Флаги</td><td>$(netstat | grep STREAM | awk '{if($4!="]"){print "</td><td>", $4}}')</td></tr>
    <tr><td>Статус</td><td>$(netstat | grep STREAM | awk '{if($6 !~ /\d+/ && $4 == "]" || $7 !~ /\d+/ && $4 != "]"){ if($4!="]"){print "</td><td>", $7}else{print "</td><td>", $6} }}')</td></tr>
    <tr><td>I-Node</td><td>$(netstat | grep STREAM | awk '{if($6 !~ /\d+/ && $4 == "]" || $7 !~ /\d+/ && $4 != "]"){ if($4!="]"){print "</td><td>", $8}else{print "</td><td>", $7} }else{ if($4!="]"){print "</td><td>", $7}else{print "</td><td>", $6} }}')</td></tr>
    <tr><td>Файл</td><td>$(netstat | grep STREAM | awk '{if($NF !~ /\d+/){print "</td><td>", $NF}}')</td></tr>
    <tr><td rowspan=6>UDP</td><td>Протокол</td><td>$(netstat | grep DGRAM | awk '{print "</td><td>", $1}')</td></tr>
    <tr><td>Кол-во ссылок</td><td>$(netstat | grep DGRAM | awk '{print "</td><td>", $2}')</td></tr>
    <tr><td>Флаги</td><td>$(netstat | grep DGRAM | awk '{if($4!="]"){print "</td><td>", $4}}')</td></tr>
    <tr><td>Статус</td><td>$(netstat | grep DGRAM | awk '{if($6 !~ /\d+/ && $4 == "]" || $7 !~ /\d+/ && $4 != "]"){ if($4!="]"){print "</td><td>", $7}else{print "</td><td>", $6} }}')</td></tr>
    <tr><td>I-Node</td><td>$(netstat | grep DGRAM | awk '{if($6 !~ /\d+/ && $4 == "]" || $7 !~ /\d+/ && $4 != "]"){ if($4!="]"){print "</td><td>", $8}else{print "</td><td>", $7} }else{ if($4!="]"){print "</td><td>", $7}else{print "</td><td>", $6} }}')</td></tr>
    <tr><td>Файл</td><td>$(netstat | grep DGRAM | awk '{if($NF !~ /\d+/){print "</td><td>", $NF}}')</td></tr>
    </tbody></table>

    <h3>Количество tcp-соединений по состояниям:</h3>
    <table class="netstat"><tbody>
    <tr><td>Состояние</td><td>ESTABLISHED</td><td>SYN_SENT</td><td>SYN_RECV</td><td>FIN_WAIT1</td><td>FIN_WAIT2</td><td>TIME_WAIT</td><td>CLOSE</td><td>CLOSE_WAIT</td><td>LAST_ASK</td><td>LISTEN</td><td>CLOSING</td><td>UNKNOWN</td></tr>
    <tr><td>Соединение</td><td>$(net ESTABLISHED)</td><td>$(net SYN_SENT)</td><td>$(net SYN_RECV)</td><td>$(net FIN_WAIT1)</td><td>$(net FIN_WAIT2)</td><td>$(net TIME_WAIT)</td><td>$(net CLOSE)</td><td>$(net CLOSE_WAIT)</td><td>$(net LAST_ASK)</td><td>$(net LISTEN)</td><td>$(net CLOSING)</td><td>$(net UNKNOWN)</td></tr>
    </tbody></table>

    <hr>
    <h1>Средняя загрузка CPU</h1>
    <table class="cpu"><tbody>
    <tr><td>CPU</td><td>%user</td><td>%system</td><td>%idle</td><td>%iowait</td></tr>
    $(mpstat -P ALL | tail -n+4  | sed -e 's/,/\./' | awk '{print "<tr><td>", $2, "</td><td>", $3+$4, "</td><td>", $5, "</td><td>", $12, "</td><td>", $6, "</td></tr>"}')
    </tbody></table>

    <hr>
    <h1>Информация о дисках</h1>
    <table class="df"><tbody>
        <tr><td>Файловая система</td><td>Размер</td><td>Использовано</td><td>Доступно</td><td>Использовано%</td><td></td><td>Инодов всего</td><td>Инодов использовано</td><td>Инодов доступно</td><td>Инодов использовано%</td><td>Смонтировано в</td></tr>
        $(join /tmp/sysinfo/df-ah /tmp/sysinfo/df-ahi | to_html | tail -n+2| awk '$6 !~ /^\/(dev|sys|proc)/ {print "<tr><td>", $1, "</td><td>", $2, "</td><td>", $3, "</td><td>", $4, "</td><td>", $5, "</td><td></td><td>", $7, "</td><td>", $8, "</td><td>", $9, "</td><td>", $10, "</td><td>", $11, "</td></tr>"}')
    </tbody></table>

    <hr>
    <h1>История:</h1>
    $( if [ $logs ]
       then
           echo "<table class='history'><tbody>
           <tr><td>Время записи</td><td>Файл лога</td></tr>
           $logs
           </tbody></table>"
       else
           echo "<p>Нет логов</p>"
       fi
     )
</body>
</html>

HTML
