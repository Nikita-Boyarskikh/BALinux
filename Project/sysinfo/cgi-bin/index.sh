#!/bin/bash

echo "Content-Type: text/html"
echo
echo $ENV

to_html() {
    cat | sed -e 's/</\&lt/g; s/>/\&gt/g' | cat
}

format() {
    cat | perl -ne'my @cols = split /\s+/, $_;
             chop $cols[4];
             if($cols[5] !~ "^/proc" and $cols[5] !~ "^/dev" and $cols[5] !~ "^/sys") {
                 if($cols[4] ne "Use" and $cols[4] > 90) {
                     print "<tr style=\"background-color: red\"><td>".$cols[0];
                 } elsif($cols[4] ne "Use" and $cols[4] > 80) {
                     print "<tr style=\"background-color: orange\"><td>".$cols[0];
                 } else {
                     print "<tr><td>".$cols[0];
                 }
                 print "</td><td>".$cols[1]."</td><td>".$cols[2]."</td><td>".$cols[3]."</td><td>".$cols[4]."%</td><td>".$cols[5]."</td></tr>";
             }
            '
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

    <p><h1>Load Average:</h1> (Ядер в системе: <b>$Cores</b>)<p>
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
    <h1>Информация о цисках</h1>
    <table class="df"><tbody>
        $(df -h | to_html | format)
    </tbody></table>
    <hr>
    <table class="iostat"><tbody>
        <tr><td></td></tr>
            $(iostat -xp | tail -n+7 |
            awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14}'
            | to_html | format)
    </tbody></table>
    <hr>
    <h1>История:</h1>
    <table class='history'><tbody>
    <tr><td>Время записи</td><td>Файл лога</td></tr>
        $(ls -ult /var/www/sysinfo/history | tail -n+2 |
        to_html | awk '{print "<tr>
            <td>"$6" "$7" "$8"</td>
            <td><a href=\"/sysinfo/history/"$9"\">"$9"</a>
            </td></tr>"}'
         )
    </tbody></table>
</body>
</html>


HTML
