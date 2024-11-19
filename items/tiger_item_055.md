# id_item

55

# learning_area

Gruppenvergleiche

# type_item

content

# bloom_taxonomy

application

# theo_diff

hard

# stimulus_text

Ein Aspekt, der bei der Borderline-Persönlichkeitsstörung (BPS) zu erheblichem Leidensdruck führt, ist eine gestörte Affektregulation, die oft mit starken Schwankungen in den Affektzuständen der PatientInnen einhergeht.

Im Rahmen eines klinischen Trials zur Wirksamkeit der dialektisch-behavioralen Therapie (DBT) bei BPS wurde unter anderem untersucht, ob diese  in der Lage ist, diese Schwankungen im Affekt zu reduzieren. Dafür wurden Patient*innen randomisiert einer Kontrollgruppe ($$n_{TAU}$$ = 101), die Treatment as Usual (TAU) erhielt und der Treatmentgruppe ($$n_{DBT}$$ = 46) zugeordet und nach Abschluss der Therapie in beiden Gruppen ein Instrument zur Messung des Affektes erhoben. Die Ergebnisse einer vorher durchgeführten Pilotstudie ergaben bereits, dass die Schwankungen in den Affektzuständen in der DBT-Gruppe im Vergleich zur TAU-Gruppe um 30 Prozent verringert werden konnten. Nach der Pilotierungsstudie wurde die Intervention weiter optimiert. Man geht davon aus, dass der Effekt dieser neuen, verbesserten Intervention in der aktuellen Studie stärker sein wird als der in der Pilotstudie gefundene Effekt.

Die deskriptiven Kennwerte der Studie sind in folgender Tabelle dargestellt:

<table>
  <tr>
    <th>Gruppe</th>
    <th>M</th>
    <th>S<sup>2</sup></th>
  </tr>
  <tr>
    <td>DBT</td>
    <td>10.8</td>
    <td>4.9</td>
  </tr>
  <tr>
    <td>TAU</td>
    <td>15.1</td>
    <td>14.3</td>
  </tr>
</table>

Berechne eine geeignete Prüfgröße, um die Hypothese zu testen und runden sie das Ergebnis auf zwei Nachkommastellen.

# stimulus_image

NA

# answeroption_01

2.07

# answeroption_02

2.95

# answeroption_03

2.04

# answeroption_04

2.92

# answeroption_05

NA

# answeroption_06

<!---
String (eines von):
    - Frage überspringen
    - www/skip.png
  
Wenn type_answer: `text`, dann "Frage überspringen"
Wenn type_answer: `image`, dann "www/skip.png
--->

Frage überspringen

# answer_correct

1

# type_stimulus

<!---
String (eines von):
    - text
    - image
Muss `text` sein, wenn als Stimulus ein Textformat genutzt wurde, und `image`, wenn als Stimulus ein Bild verwendet wurde.
--->

text

# type_answer

<!---
String (eines von):
    - text
    - image
Muss `text` sein, wenn als Antwortoptionen ein Textformat genutzt wurde, und `image`, wenn als Antwortoptionen Bilder verwendet wurden.
--->

text

# if_answeroption_01

Richtig, seht gut! Du hast erkannt, dass es sich um einen F-Test handelt. Die Stichprobenstandardabweichungen hast du richtigerweise  in geschätzte Populationsvarianzen umgerechnet und dann bei der Teststatistik darauf geachtet, dass die H0 nicht $$\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=1$$, sondern $$\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=0.7$$ war. Hier nochmal ein möglicher Rechenweg:

# if_answeroption_02

Leider falsch. Du hast zwar erkannt, dass es sich um einen F-Test handelt und korrekterweise die Stichprobenvarianzen in geschätzten Populationsvarianzen umgerechnet. Allerdings hast du nicht berücksichtigt, dass die H0 nicht $$\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=1$$, sondern $$\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=0.7$$ war. Dies war in der Aufgabe, durch die 30% Reduktion der Variabilität der DBT-Gruppe im Vergleich zur TAU-Gruppe impliziert. 

# if_answeroption_03

Leider falsch. Du hast hast zwar erkannt, dass es sich um einen F-Test handelt und hast korrekterweise nicht die Nullhypothese nicht $\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=1$, sondern $\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=0.7$ getestet. Allerdings hast du nicht berücksichtigt, dass die Stichprobenvarianzen für die Teststatistik noch in geschätzte Populationsvarianzen umgerechnet werden müssen. 

# if_answeroption_04

Leider falsch. Du hast zwar erkannt, dass es sich um einen F-Test handelt, hast jedoch an zwei Stellen einen Fehler gemacht. Erstens musst statt der angegeben Stichprobenvarianzen diese in geschätzte Populationsvarianzen umrechnen. Zweitens war nicht nach der Nullhypothese  $\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=1$, sondern $\sigma^2_{\text{DBT}}/\sigma^2_{\text{TAU}}=0.7$ in der Aufgabenstellung gefragt. Dies war in der Aufgabe, durch die 30% Reduktion der Variabilität der DBT-Gruppe im Vergleich zur TAU-Gruppe impliziert.

# if_answeroption_05

NA

# if_answeroption_06

<!--
Bitte so lassen.
-->

Alles klar! Du hast die Aufgabe übersprungen.