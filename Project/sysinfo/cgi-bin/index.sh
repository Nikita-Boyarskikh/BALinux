#!/bin/bash

appdir='/var/www/sysinfo'
tempdir='/tmp/sysinfo'

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

if [[ $(echo "(($LoadAvg1 - $LoadAvg2) > 0.05*$Cores) && (($LoadAvg2 - $LoadAvg3) > 0.01*$Cores)" | bc) = 1 ]]
then
    Status="Наблюдается рост!"
    if [[ $(echo "$LoadAvg1 < 0.3*$Cores" | bc) = 1 ]]
    then
        STYLE="$STYLE
               .Status { color: green }"
    elif [[ $(echo "$LoadAvg1+0.3 > $Cores" | bc) = 1 ]]
    then
        STYLE="$STYLE
               .Status { color: red !important; text-decoration: bold }"
    fi
elif [[ $(echo "(($LoadAvg1 - $LoadAvg2) < -0.05*$Cores) && (($LoadAvg2 - $LoadAvg3) < -0.01*$Cores)" | bc) = 1 ]]
then
    Status="Наблюдается спад!"
    if [[ $(echo "$LoadAvg1 < 0.3*$Cores" | bc) = 1 ]]
    then
        STYLE="$STYLE
               .Status { color: red !important; text-decoration: bold }"
    elif [[ $(echo "$LoadAvg1+0.3 > $Cores" | bc) = 1 ]]
    then
        STYLE="$STYLE
               .Status { color: green }"
    fi
else
    Status="Стабильно!"
    if [[ $(echo "($LoadAvg1 < 0.1*$Cores) || ($LoadAvg1 >= $Cores)" | bc) = 1 ]]
    then
        STYLE="$STYLE
               .Status { color: red !important; text-decoration: bold }"
    elif [[ $(echo "(($LoadAvg1+0.3) < $Cores) && ($LoadAvg > 0.3*$Cores)" | bc) = 1 ]]
    then
        STYLE="$STYLE
               .Status { color: green }"
    fi
fi

if [[ $(echo "($LoadAvg1 >= $Cores) || ($LoadAvg1 < 0.1*$Cores)" | bc) = 1 ]]
then
    STYLE="$STYLE
           .loadavg1 { background-color:red !important}"
elif [[ $(echo "(($LoadAvg1 + 0.3) > $Cores) || ($LoadAvg1 < 0.3*$Cores)" | bc) = 1 ]]
then
    STYLE="$STYLE
           .loadavg1 { background-color:orange }"
fi

if [[ $(echo "($LoadAvg2 >= $Cores) || ($LoadAvg2 < 0.1*$Cores)" | bc) = 1 ]]
then
    STYLE="$STYLE
           .loadavg2 { background-color:red !important}"
elif [[ $(echo "(($LoadAvg2 + 0.3) > $Cores) || ($LoadAvg2 < 0.3*$Cores)" | bc) = 1 ]]
then
    STYLE="$STYLE
           .loadavg2 { background-color:orange }"
fi

if [[ $(echo "($LoadAvg3 >= $Cores) || ($LoadAvg3 < 0.1*$Cores)" | bc) = 1 ]]
then
    STYLE="$STYLE
           .loadavg3 { background-color:red !important}"
elif [[ $(echo "(($LoadAvg3 + 0.3) > $Cores) || ($LoadAvg3 < 0.3*$Cores)" | bc) = 1 ]]
then
    STYLE="$STYLE
           .loadavg3 { background-color:orange }"
fi

logs=$(ls -ult $appdir/history | tail -n+2 | to_html | \
       awk '{print "<tr><td>"$6" "$7" "$8"</td><td><a href=\"/sysinfo/history/"$9"\">"$9"</a></td></tr>"}'
      )

net() {
    count=$(ls $tempdir/netstat | wc -l)
    res=0
    for ((i=0;i<$count;i++))
    do
        add=$(cat $tempdir/netstat/$i | cut -d'
' -f`echo $1`)
        res=$(echo "$res + $add" | bc)
    done
    res=$(echo "scale=1; $res/$count" | bc)
    echo 0$res
}

proc() {
    dir=procfs
    res1=$(cat $tempdir/$dir/0 | to_html | awk '{print $1}')
    res2=0
    res3=0
    res4=0
    res5=0
    res6=0
    res7=0
    res8=0
    res9=0
    res10=0
    res11=0
    res12=0
    res13=0
    res14=0
    res15=0
    res16=0
    res17=0
    count=$(ls $tempdir/$dir | wc -l)
    for ((i=0;i<$count;i++))
    do
        add2=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $2}')
        add3=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $3}')
        add4=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $4}')
        add5=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $5}')
        add6=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $6}')
        add7=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $7}')
        add8=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $8}')
        add9=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $9}')
        add10=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $10}')
        add11=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $11}')
        add12=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $12}')
        add13=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $13}')
        add14=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $14}')
        add15=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $15}')
        add16=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $16}')
        add17=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $17}')
        res2=$(echo "$res2 + $add2" | bc)
        res3=$(echo "$res3 + $add3" | bc)
        res4=$(echo "$res4 + $add4" | bc)
        res5=$(echo "$res5 + $add5" | bc)
        res6=$(echo "$res6 + $add6" | bc)
        res7=$(echo "$res7 + $add7" | bc)
        res8=$(echo "$res8 + $add8" | bc)
        res9=$(echo "$res9 + $add9" | bc)
        res10=$(echo "$res10 + $add10" | bc)
        res11=$(echo "$res11 + $add11" | bc)
        res12=$(echo "$res12 + $add12" | bc)
        res13=$(echo "$res13 + $add13" | bc)
        res14=$(echo "$res14 + $add14" | bc)
        res15=$(echo "$res15 + $add15" | bc)
        res16=$(echo "$res16 + $add16" | bc)
        res17=$(echo "$res17 + $add17" | bc)
    done
    res2=$(echo "scale=1; $res2 / $count" | bc)
    res3=$(echo "scale=1; $res3 / $count" | bc)
    res4=$(echo "scale=1; $res4 / $count" | bc)
    res5=$(echo "scale=1; $res5 / $count" | bc)
    res6=$(echo "scale=1; $res6 / $count" | bc)
    res7=$(echo "scale=1; $res7 / $count" | bc)
    res8=$(echo "scale=1; $res8 / $count" | bc)
    res9=$(echo "scale=1; $res9 / $count" | bc)
    res10=$(echo "scale=1; $res10 / $count" | bc)
    res11=$(echo "scale=1; $res11 / $count" | bc)
    res12=$(echo "scale=1; $res12 / $count" | bc)
    res13=$(echo "scale=1; $res13 / $count" | bc)
    res14=$(echo "scale=1; $res14 / $count" | bc)
    res15=$(echo "scale=1; $res15 / $count" | bc)
    res16=$(echo "scale=1; $res16 / $count" | bc)
    res17=$(echo "scale=1; $res17 / $count" | bc)
    echo "<tr><td> $res1 </td><td></td><td> $res2 </td><td> $res3 </td><td> $res4 </td><td> $res5 </td><td> $res6 </td><td>\
          $res7 </td><td> $res8 </td><td> $res9 </td><td></td><td> $res10 </td><td> $res11 </td><td> $res12 </td><td> $res13 \
          </td><td> $res14 </td><td> $res15 </td><td> $res16 </td><td> $res17 </td></tr>"
}

mps() {
    dir=mpstat
    res3=$(cat $tempdir/$dir/0 | to_html | awk '{print $3}')
    res45=0
    res6=0
    res13=0
    res7=0
    count=$(ls $tempdir/$dir | wc -l)
    for ((i=0;i<$count;i++))
    do
        add4=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $4}')
        add5=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $5}')
        add6=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $6}')
        add13=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $13}')
        add7=$(cat $tempdir/$dir/$i | awk "(NR == `echo $n`)" | awk '{print $7}')
        res45=$(echo "$res45 + $add5 + $add4" | bc)
        res6=$(echo "$res6 + $add6" | bc)
        res13=$(echo "$res13 + $add13" | bc)
        res7=$(echo "$res7 + $add7" | bc)
    done
    res45=$(echo "scale=1; $res45 / $count" | bc)
    res6=$(echo "scale=1; $res6 / $count" | bc)
    res13=$(echo "scale=1; $res13 / $count" | bc)
    res7=$(echo "scale=1; $res7 / $count" | bc)
    echo "<tr><td> $res3 </td><td> $res45 </td><td> $res6 </td><td> $res13 </td><td> $res7  </td></tr>"
}

dfree() {
    dir=df
    res1=$(cat $tempdir/$dir/0 | to_html | awk '{print $1}')
    res2=$(cat $tempdir/$dir/0 | to_html | awk '{print $2}')
    res11=$(cat $tempdir/$dir/0 | to_html | awk '{print $11}')
    res12=$(cat $tempdir/$dir/0 | to_html | awk '{print $12}')
    res3=0
    res4=0
    res5=0
    res6=0
    res7=0
    res8=0
    res9=0
    res10=0
    count=$(ls $tempdir/$dir | wc -l)
    for ((i=0;i<$count;i++))
    do
        add3=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $3}')
        add4=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $4}')
        add5=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $5}')
        add6=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $6}')
        add7=$(cat $tempdir/$dir/$i | awk "(NR == `echo $n`)" | awk '{print $7}')
        add8=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $8}')
        add9=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $9}')
        add10=$(cat $tempdir/$dir/$i | awk "(NR == `echo $n`)" | awk '{print $10}')
        add6=${adds6::${#add6}-1}
        add10=${add10::${#add10}-1}
        res4=$(echo "$res4 + $add4" | bc)
        res5=$(echo "$res5 + $add5" | bc)
        res6=$(echo "$res6 + $add6" | bc)
        res7=$(echo "$res7 + $add7" | bc)
        res8=$(echo "$res8 + $add8" | bc)
        res9=$(echo "$res9 + $add9" | bc)
        res10=$(echo "$res10 + $add10" | bc)
    done
    res4=$(echo "scale=1; $res4 / $count" | bc)
    res5=$(echo "scale=1; $res5 / $count" | bc)
    res6=$(echo "scale=1; $res6 / $count" | bc)
    res7=$(echo "scale=1; $res7 / $count" | bc)
    res8=$(echo "scale=1; $res8 / $count" | bc)
    res9=$(echo "scale=1; $res9 / $count" | bc)
    res10=$(echo "scale=1; $res10 / $count" | bc)
    echo "<tr><td> $res1 </td><td> $res2 </td><td> $res3 </td><td> $res4 </td><td> $res5 </td><td></td><td> $res6 </td>\
    <td> $res7 </td> $res8 </td><td> $res9 </td><td> $res10 </td><td> $res11 </td><td> $res12 </td></tr>"
}

ios() {
    dir=iostat
    res1=$(cat $tempdir/$dir/0 | to_html | awk '{print $1}')
    res4=0
    res5=0
    res10=0
    res14=0
    res55=0
    res66=0
    count=$(ls $tempdir/$dir | wc -l)
    count=$(echo "$count / 2" | bc)
    n=$(cat $tempdir/$dir/0 | wc -l)
    n=$(echo "$n/2 + $1" | bc)
    for ((i=0;i<$count;i++))
    do
        add4=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $4}')
        add5=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $5}')
        add10=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $10}')
        add14=$(cat $tempdir/$dir/$i | awk "(NR == `echo $1`)" | awk '{print $14}')
        add55=$(cat $tempdir/$dir/$i-1 | awk "(NR == `echo $n`)" | awk '{print $5}')
        add66=$(cat $tempdir/$dir/$i-1 | awk "(NR == `echo $n`)" | awk '{print $6}')
        res4=$(echo "$res4 + $add4" | bc)
        res5=$(echo "$res5 + $add5" | bc)
        res10=$(echo "$res10 + $add10" | bc)
        res14=$(echo "$res14 + $add14" | bc)
        res55=$(echo "$res55 + $add55" | bc)
        res66=$(echo "$res66 + $add66" | bc)
    done
    res4=$(echo "scale=1; $res4 / $count" | bc)
    res5=$(echo "scale=1; $res5 / $count" | bc)
    res10=$(echo "scale=1; $res10 / $count" | bc)
    res14=$(echo "scale=1; $res14 / $count" | bc)
    res55=$(echo "scale=1; $res55 / $count" | bc)
    res66=$(echo "scale=1; $res66 / $count" | bc)
    echo "<tr><td> $res1 </td><td> $res55 </td><td> $res66 </td><td> $res4 </td><td> $res5 </td><td> $res10 </td><td> $res14 </td></tr>"
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
    <p class="Status">$Status</p>

    <hr>
    <h1>Загрузка дисков</h1>
    <table class="iostat"><tbody>
    <tr><td>Устройство</td><td>Всего прочитано (Кб)</td><td>Всего записано (Кб)</td><td>Чтение (Кб/c)</td><td>Запись (Кб/с)</td><td>Время обработки запроса (мс)</td><td>% утилизации</td></tr>
    $(n=$(cat $tempdir/iostat/0 | wc -l); for ((i=0;i<$n;i++)); do ios $i; done)
    </tbody></table>

    <hr>
    <h1>Загрузка сети</h1>
    <table class="procfs"><tbody>
    <tr><td rowspan=2>Inter-face</td><td rowspan=2></td><td colspan=8 align="center">Receive</td><td></td>
        <td colspan=8 align="center">Transmit</td>
    </tr>
    <tr><td>bytes</td><td>packets</td><td>errs</td><td>drop</td><td>fifo</td><td>frame</td><td>compressed</td><td>multicast</td><td></td>
        <td>bytes</td><td>packets</td><td>errs</td><td>drop</td><td>fifo</td><td>colls</td><td>carrier</td><td>compressed</td>
    </tr>
    $(n=$(cat $tempdir/procfs/0 | wc -l); for ((i=0;i<$n;i++)); do proc $i; done)
    </tbody></table>

    <hr>
    <h1>Top talkers</h1>
    tcpdump

    <hr>
    <h1>Информация о сетевых соединениях</h1>
    <h3>Слушающие сокеты:</h3>
    <table class="sockets"><tbody>
    <tr><td rowspan=4>TCP</td><td>Очередь отправки</td><td>$(netstat -ant | awk '/^tcp/ {print $2}')</td></tr>
    <tr><td>Очередь приёма</td><td>$(netstat -ant | awk '/^tcp/ {print $3}')</td></tr>
    <tr><td>Локальный адрес</td><td>$(netstat -ant | awk '/^tcp/ {print $4}')</td></tr>
    <tr><td>Удалённый адрес</td><td>$(netstat -ant | awk '/^tcp/ {print $5}')</td></tr>
    <tr><td rowspan=4>UDP</td><td>Очередь отправки</td><td>$(netstat -ant | awk '/^udp/ {print $2}')</td></tr>
    <tr><td>Очередь приёма</td><td>$(netstat -ant | awk '/^udp/ {print $3}')</td></tr>
    <tr><td>Локальный адрес</td><td>$(netstat -ant | awk '/^udp/ {print $4}')</td></tr>
    <tr><td>Удалённый адрес</td><td>$(netstat -ant | awk '/^udp/ {print $5}')</td></tr>
    </tbody></table>

    <h3>Количество tcp-соединений по состояниям:</h3>
    <table class="netstat"><tbody>
    <tr><td>Состояние</td><td>ESTABLISHED</td><td>SYN_SENT</td><td>SYN_RECV</td><td>FIN_WAIT1</td><td>FIN_WAIT2</td><td>TIME_WAIT</td>
        <td>CLOSE</td><td>CLOSE_WAIT</td><td>LAST_ASK</td><td>LISTEN</td><td>CLOSING</td><td>UNKNOWN</td>
    </tr>
    <tr><td>Соединение</td><td>$(net 1)</td><td>$(net 2)</td><td>$(net 3)</td><td>$(net 4)</td><td>$(net 5)</td><td>$(net 6)</td>
        <td>$(net 7)</td><td>$(net 8)</td><td>$(net 9)</td><td>$(net 10)</td><td>$(net 11)</td><td>$(net 12)</td>
    </tr>
    </tbody></table>

    <hr>
    <h1>Средняя загрузка CPU</h1>
    <table class="cpu"><tbody>
    <tr><td>CPU</td><td>%user</td><td>%system</td><td>%idle</td><td>%iowait</td></tr>
    $(n=$(cat $tempdir/mpstat/0 | wc -l); for ((i=0;i<$n;i++)); do mps $i; done)
    </tbody></table>

    <hr>
    <h1>Информация о дисках</h1>
    <table class="df"><tbody>
    <tr><td>Файловая система</td><td>Размер</td><td>Использовано</td><td>Доступно</td><td>Использовано%</td><td></td>
        <td>Инодов всего</td><td>Инодов использовано</td><td>Инодов доступно</td><td>Инодов использовано%</td><td>Файл</td><td>Смонтировано в</td>
    </tr>
    $(n=$(cat $tempdir/df/0 | wc -l); for ((i=0;i<$n;i++)); do dfree $i; done)
    </tbody></table>

    <hr>
    <h1>История:</h1>
    $( if [[ $logs ]]
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
