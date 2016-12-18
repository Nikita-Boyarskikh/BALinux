#!/bin/bash

echo "Content-Type: text/html"
echo

to_html() {
    cat | sed -e 's/</\&lt/g; s/>/\&gt/g' | cat
}

STYLE="body {}
       table { border-collapse: collapse}
       td { border: solid black 1px }
       h1 { margin: 1px }"

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

if [ $(perl -e"print $LoadAvg1 > $Cores") ]
then
    STYLE="$STYLE
           .loadavg1 { background-color:red }"
elif [ $(perl -e"print(($LoadAvg1 + 0.3) > $Cores)") ]
then
    STYLE="$STYLE
           .loadavg1 { background-color:orange }"
fi

if [ $(perl -e"print $LoadAvg2 > $Cores") ]
then
    STYLE="$STYLE
           .loadavg2 { background-color:red }"
elif [ $(perl -e"print(($LoadAvg2 + 0.3) > $Cores)") ]
then
    STYLE="$STYLE
           .loadavg2 { background-color:orange }"
fi

if [ $(perl -e"print $LoadAvg3 > $Cores") ]
then
    STYLE="$STYLE
           .loadavg3 { background-color:red }"
elif [ $(perl -e"print(($LoadAvg3 + 0.3) > $Cores)") ]
then
    STYLE="$STYLE
           .loadavg3 { background-color:orange }"
fi

netstat() {
    netstat | awk '{print }' | grep -c $1
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
    <table><tbody>
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
        $(iostat -xp | tail -n+6 | head -n-1 | to_html | awk '{print "<tr><td>", $1, "</td><td>, $4, "</td><td>", $5, "</td><td>", $10, "</td><td>", $14, "</td></tr>"}')
    </tbody></table>

    <hr>
    <table><tbody>
    <tr><td rowspan=2>Inter-
                      face</td><td rowspan=2></td><td colspan=8 align="center">Receive</td><td></td><td colspan=8 align="center">Transmit</td></tr>
    <tr><td>bytes</td><td>packets</td><td>errs</td><td>drop</td><td>fifo</td><td>frame</td><td>compressed</td><td>multicast</td><td></td>
        <td>bytes</td><td>packets</td><td>errs</td><td>drop</td><td>fifo</td><td>colls</td><td>carrier</td><td>compressed</td></tr>
    $(cat /proc/net/dev | tail -n+3 | awk '{print "<tr><td>", $1, "</td><td></td><td>", $2, "</td><td>", $3, "</td><td>", $4, "</td><td>", $5, "</td><td>", $6, "</td><td>", $7, "</td><td>", $8, "</td><td>", $9, "</td><td></td><td>", $10, "</td><td>", $11, "</td><td>", $12, "</td><td>", $13, "</td><td>", $14, "</td><td>", $15, "</td><td>", $16, "</td><td>", $17, "</td></tr>"}')
    </tbody></table>

    <hr>
    tcpdump

    <hr>
    netstat | awk '{print $6}' | grep -c CONNECTED

    <hr>
    mpstat | tail -n+4  | sed -e 's/,/\./' | awk '{print $3+$4, $5, $12, $6}'

    <hr>
    <h1>Информация о дисках</h1>
    <table class="df"><tbody>
        $(df -h | to_html | awk '$6 !~ /^\/(dev|sys|proc)/ {print "<tr><td>", $1, "</td><td>", $2, "</td><td>", $3, "</td><td>", $4, "</td><td>", $5, "</td><td>", $6, "</td></tr>"}')
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
