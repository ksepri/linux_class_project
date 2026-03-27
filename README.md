Autor: Ksenia P, Bioinformatyka, 2025/2026
Projekt: notatnik, w którym utworzysz listę rzeczy do zrobienia w danym dnu. 

Program znajduje się w pliku 'main.sh'. Używa LaTeX do tworzenia pdf-plików, pakietu evince do ich obsługi. Aby program działał poprawnie, konieczna jest obecność podkatalogów 'days_txt', 'days_tex' oraz 'days_pdf'.

Program działa jako kalendarz, w którym można zapisywać wydarzenia i usuwać je. Wszystkie wydarzenia na dany dzień można zobaczyć w formacie pliku PDF.

Oczywiście jest wiele rzeczy do zrobienia, aby program poprawnie obsługiwał wyjątkowe sytuacje. Istnieją pewne ograniczenia w jego działaniu. Program nie zadziała poprawnie, jeśli:
1. Spacja będzie użyta nie jako separator między argumentami komendy; 
2. Użyjesz innej kolejności argumentów w poleceniu, ponieważ to nie jest sprawdzane;
3. Użyjesz innej liczby argumentów. 

W takim wypadku trzeba ręcznie zmienić zawartość lub nazwę odpowiednich plików .txt, .tex. 
