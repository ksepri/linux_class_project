#!/bin/bash 

# polecenia w kolendarzu
my_calendar_do=('addevent' 'day' 'deleteevent' 'exit' 'help')

echo "Cześć! To jest twój notatnik na rzeczy do zrobienia w pewnym dniu. Użyj \"help\", żeby zobaczyć, jak działa program."
echo ""

# odczyt danych
read user_input
to_do=$(echo $user_input | awk '{print $1}')

# póki nie użyte polecenie 'exit', wykonuj pętlę
while [[ "$to_do" != "${my_calendar_do[3]}" ]]; do

#JEŻELI UŻYTA KOMENDA 'HELP'
if [[ "$to_do" = "${my_calendar_do[4]}" ]]; then
	echo "addevent - doda wydarzenie do rozkładu;"
	echo "addevent data-wydarzenia nazwa-wydarzenia czas-wydarzenia"
	echo "Np.: addevent 12-12-2020 spacer-z-psem 12:00"
	echo ""
	echo "day - wyświetli plik PDF z twoim rozkładem;"
	echo "day data-wydarzenia"
	echo "Np.: day 12-12-2020"
	echo ""
	echo ""
	echo "deleteevent - usunie wydarzenie z rozkładu;"
	echo "deleteevent data-wydarzenia nazwa-wydarzenia"
	echo "Np.: deleteevent 12-12-2020 spacer-z-psem"
	echo ""
	echo ""
	echo "exit - zamknie program"
	echo "Chcesz kontynuować? Napisz polecenie tu."
else

event_date=$(echo $user_input | awk '{print $2'})
day_table="$(pwd)/days_txt/day${event_date}.txt"
day_tex="$(pwd)/days_tex/day${event_date}.tex"


# utworzenie plików .txt oraz .tex, w których będą póżniej zapisywane rzeczy do zrobienia w pewnym dniu 
if [[ ! -f $day_table && "$to_do" != "${my_calendar_do[3]}" ]]; then
	touch $day_table
	chmod 700 $day_table

  	touch $day_tex
  	chmod 700 $day_tex

	# skrypt dla latex-pliku
  	echo "\documentclass{article}" >> $day_tex
  	echo "\usepackage[polish]{babel}" >> $day_tex
	echo "\begin{document}" >> $day_tex
	echo "\begin{center}" >> $day_tex
	echo "{\fontsize{24}{20}\selectfont{Twój rozkład}}\\\\[1,5 em]" >> $day_tex
	echo "{\fontsize{16}{20}\selectfont ${event_date}}\\\\[1 em]" >> $day_tex
	echo "{\fontsize{14}{18}\selectfont" >> $day_tex
	echo "\begin{tabular}{|c|c|}" >> $day_tex
  	echo "\hline" >> $day_tex
	echo "Event & Time" >> $day_tex
  	echo "\input{${day_table}} \\\\" >> $day_tex
	echo "\hline" >> $day_tex
	echo "\end{tabular}}" >> $day_tex
	echo "\end{center}" >> $day_tex
	echo "\end{document}" >> $day_tex

fi

#JEŻELI CHCESZ DODAĆ WYDARZENIE W PEWNYM DNIU. KOMENDA 'ADDEVENT'
if [[ "$to_do" = "${my_calendar_do[0]}" ]]; then
event_name=$(echo $user_input | awk '{print $3}')
event_time=$(echo $user_input | awk '{print $4}')
echo "Wydarzenie zostało dodane!"
echo "\\\\ \\hline $event_name & $event_time" >> $day_table

#-------------------------------------
#-------------------------------------
#-------------------------------------

#JEŻELI CHCESZ ZOBACZYC ROZKLAD W PEWNYM DNIU. KOMENDA 'DAY'
elif [[ "$to_do" = "${my_calendar_do[1]}" ]]; then
	if ! find "$(pwd)/days_txt"  "$day_table"| grep -q .; then
		echo "Rozkład na ${event_date} jeszcze nie został stworzony. Spróbuj inny dzień."
	else 
		pdflatex -output-directory="$(pwd)/days_pdf" "$day_tex" > "$(pwd)/days_tex/day${event_date}.log" 2>&1
		echo "Stworzono pdf plik z twoim rozkładem. Sprawdź go tu:$(pwd)/days_pdf/day${event_date}.pdf"
		evince "$(pwd)/days_pdf/day${event_date}.pdf" &
	fi
	echo "Kontynuuj lub zamknij program."

#-------------------------------------
#-------------------------------------
#-------------------------------------

#JEŻELI CHCESZ USUNĄĆ WYDARZENIE Z ROZKŁADU W PEWNYM DNIU. KOMENDA 'DELETEEVENT'
elif [[ "$to_do" = "${my_calendar_do[2]}" ]]; then
	event_date=$(echo $user_input | awk '{print $2}')
	event_name=$(echo $user_input | awk '{print $3}')
	
        if ! find "$(pwd)/days_txt"  "$day_table"| grep -q .; then
		echo "Rozkład na ${event_date} jeszcze nie został stworzony. Spróbuj inny dzień."
	elif grep -i -q -E " ${event_name} &" $day_table; then
		sed -i "/ ${event_name} & /d" $day_table 
		pdflatex -output-directory="$(pwd)/days_pdf" $day_tex > "$(pwd)/days_tex/day${event_date}.log" 2>&1
		echo "Wydarzenie \"${event_name}\" zostało usunięte z rozkładu na dzień ${event_date}."
	else
		echo "Nie ma takiego wydarzenia w rozkładzie. Spróbuj innego."
	fi	

#-------------------------------------
#-------------------------------------
#-------------------------------------

else
	echo "Nie ma polecenia \"${to_do}\". Spróbuj innego lub użyj \"help\"."
fi
fi
read user_input
to_do=$(echo $user_input | awk '{print $1}')
done

#JEŻELI UŻYTE POLECENIE 'EXIT'
echo "Do zobaczenia!"
