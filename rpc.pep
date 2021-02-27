
;   UQAM - INF2170
; Organisation des ordinateurs et assembleur
;
; @author Cissé Saliou (CISS20129907)
; @author Hadji Nadir  (HADN08069703)
; 
; rpc: est un programme qui représente un jeu de roche-papier-ciseau entre
; deux joueurs humains.


; Affichage du message de Bienvenue du programme
msg_b:           stro  strLigne,d  
                 stro strTiret,d
                 stro strP,d 
                 stro strTiret,d 
                 stro  strLigne,d 
; Affichage du message de sollicitation du nombre de manches à jouer
msg_sol:         stro strSol,d 
; Sollicitation du nombre de manche à jouer ( Valeur entière > 0)
entree:          deci nbrManc,d  
                 lda  nbrManc,d  
                 sta  reste,d   

; Utilisation d'une boucle pour verifier la parité du nombre de manche 
; à jouer sans utiliser de division.
; On effectue des soustraction successives de 2 sur le nombre de manches
; jusqu'à trouver un reste de 0 ou 1
; si la valeur de reste est 0 (pair), et 1 (impair)

do:              lda reste,d  
                 suba 2,i    
                 sta reste,d  
                 lda quotient,d
                 adda 1,i
                 sta quotient,d
while:           lda reste,d   ;tant que reste est superieur à 2   
                 cpa deux,d 
                 brgt do    

; Determination du seuil de victoire par rapport au nombre de manche
; le quotient de la division par 2 determine le quota à atteindre pour
; prononcer le gagnant  
sv:              lda quotient,d 
                 adda 1,i
                 sta svict,d 
                 
; Verification de la valeur du reste
verif:           lda reste,d   ;
                 cpa 2,i
                 breq pair
                 lda reste,d 
                 cpa 0,i
                 breq pair
; Si le nombre de manche choisie est inferieur ou égale à zero 
; marque l'arrêt du programme
rej:             lda nbrManc,d
                 cpa 0,i
                 brle invalide    
; Si le nombre de manche saisi est impair, marque le demarrage 
; du jeu                  
psImpair:        br depart
; Si le nombre de manche est pair, alors on incrémente la valeur 
; de 1 pour demarrer le jeu
pair:            lda svict,d
                 adda 1,i
                 sta svict,d
                 
                 lda nbrManc,d  
                 adda 1,i       
                 sta  nbrManc,d 
                 br   depart

; Affichage du nombre restant de manche à jouer          
depart:          stro  strMr,d 
                 deco   nbrManc,d 
                 stro strMr2,d

; Affichage du message de sollicitation du joueur 1
j1:              charo 0x000A,i  
                 stro joueur1,d 
                 stro msgChois,d 
; Saisie du choix du joueur 1 
                 chari chrJ1,d   
                 
; Validation du choix du joueur 1
; Si le joueur rentre les valeurs (r,p,c), ça valide
; sinon provoque l'arrêt automatique du programme.  
valideJ1:        lda  chrJ1tp,d      
                 cpa    'r',i
                 breq j2          
                 cpa   'p',i 
                 breq j2  
                 cpa 'c', i
                 breq j2
                 br invalide
; Message d'erreur de validation des choix de joueur 
; marquant la fin du programme.
invalide:        stro  strMerr,d
                 br    sortie        

; Affichage du message de sollicitation du joueur 2
j2:              stro joueur2,d
                 stro msgChois,d ;
                 chari chrJ2, d  ;vider la valeur du choixJ2
; Saisie du choix du joueur 2
                 chari chrJ2, d
              
; Validation du choix du joueur 2 
; Si le joueur rentre les valeurs permises (r,p,c) pour continuer
; sinon provoque l'arrêt normale du programme pour valeur invalide.
valideJ2:        lda chrJ2tp,d 
                 cpa 'r',i
                 breq jeu
                 cpa 'p',i
                 breq jeu  
                 cpa 'c',i
                 breq jeu
                 br invalide
; Logique de jeu et allocation du score 
; Si le choix des deux joueurs est identique alors affiche
; le message du match nulle et recommence la partie
jeu:             lda chrJ1tp,d
                 cpa chrJ2tp,d
                 breq mNull
; Si le joueur 1 joue roche, alors on verifie le choix du 
; joueur 2
cas1:            lda chrJ1tp,d
                 cpa 'r',i 
                 breq cel1
; Si le joueur 1 joue ciseau, alors on verifie le choix du
; joueur 2
cas2:            lda chrJ1tp,d
                 cpa 'c',i
                 breq cel2 
; Mais si le joueur 2 joue roche, alors on verifie le choix 
; du joueur 1
cas3:            lda chrJ2tp,d
                 cpa 'r',i 
                 breq del1
; Mais si le joueur 2 joue papier, alors on verifie le choix 
; du joueur 1   
cas4:            lda chrJ1tp,d 
                 cpa 'p',i 
                 breq cel3
; Affichage du message de match nulle                  
mNull:           stro strMnul,d 
                 chari chrJ1,d
                 br depart
                                
; Incrémentation du score de joueur 1 en cas de victoire potentiel
; dans une manche
vicJ1:           lda scoreJ1,d
                 adda 1,i
                 sta scoreJ1,d
                 stro joueur1,d
                 br  victM
; Incrémentation du score du joueur 2 en cas de victoire lors de 
; la manche
vicJ2:           lda scoreJ2,d
                 adda 1,i
                 sta scoreJ2,d
                 stro joueur2,d
                 br victM

; Phase de transition du jeu par rapport au (cas1, cas2, cas3, cas4)
; cel1: Si le joueur 2 joue ciseau
; donc le joueur 1 gagne la manche
cel1:            lda chrJ2tp,d 
                 cpa 'c',i 
                 breq vicJ1 
; Si le joueur 2 joue papier
; donc le joueur 2 gagne la manche
                 cpa 'p',i
                 breq vicJ2 
                 br cas2 
; cel2: Si le joueur 2 joue papier 
; donc le joueur 1 gagne la manche            
cel2:            lda chrJ2tp,d 
                 cpa 'p',i 
                 breq vicJ1
                 br cas3
; cel3: Si le joueur 2 joue roche
; donc le joueur 1 gagne la manche
cel3:            lda chrJ2tp,d 
                 cpa  'r',i 
                 breq vicJ1
; sinon s'il joue ciseau donc le joueur
; 2 remporte la manche
                 cpa 'c',i 
                 breq vicJ2                
; del3: Si le joueur 1 joue ciseau
; donc le joueur 2 qui gagne la manche
del1:            lda chrJ1tp,d
                 cpa 'c',i
                 breq vicJ2
; sinon si le joueur 1 joue papier  
; donc le joueur 1 qui remporte la manche
                 cpa 'p',i
                 breq vicJ1
                 br cas2

; Affichage du message de victoire et du score d'une manche 
victM:           stro strVmc,d     
                 deco scoreJ1,d 
                 stro strT,d     
                 deco scoreJ2,d   

; Condition  pour la fin du jeu.
; Après chaque manche on decremente le nombre de manche de 1 
; (nbrManc - 1) puis on incremente le score (scoreJ1/scoreJ2 + 1) du gagnant 
; jusqu'à ce que  le nombre de manche (nbrManc = 0) 
; oubien un joueur depasse le seuil de victoire (scoreJ1/scoreJ2 > seuil)  

finJeu:          lda nbrManc,d
                 suba 1,i 
                 sta nbrManc,d
                 chari chrJ1,d
                 charo 0x000A,i
; Comparaison des scores par rapport au seuil
; de victoire 
                 lda svict,d
                 cpa scoreJ1,d
                 breq gagne
                 lda svict,d 
                 cpa scoreJ2,d
                 breq gagne
; Verification qu'il reste encore des manches
; a jouer
                 lda nbrManc,d
                 cpa 0,i 
                 brne depart
; Affichage du nom de vainqueur  
gagne:           lda scoreJ1,d   
                 cpa scoreJ2,d
                 brgt gagneJ1 
                 charo '\n',i
                 stro joueur2,d
                 br finP
gagneJ1:         charo 0x000A,i
                 stro joueur1,d
                 br finP
; Affichage du score de fin de match des 
; deux joueurs.
finP:            stro strMmc,d 
                 charo 0x000A,i
                 stro strSfin,d 
                 deco scoreJ1,d
                 stro strT,d
                 deco scoreJ2,d    
                              
sortie:                 stop


;////////////////////////// Les variables/////////////////////////////

nbrManc:         .word  0                 ;le nombre de manches à jouer
reste:           .word 0                  ;reste de la variable assigné
quotient:        .word 0                  ;le quotient de la victoire
deux:            .word 2                  ;initialisation de la constante de parité
zero:            .word 0                  ;initialisation de la variable zero
imp:             .word 0                  ;initialisation de la valeur impair
scoreJ1:         .word 0                  ;le score du joueur 1
scoreJ2:         .word 0                  ;le score du joueur 2
svict:           .word 0                  ;le seuil de victoire du match
chrJ1tp:         .byte 0
chrJ1:           .byte 0                  ;choix du joueur 1
chrJ2tp:         .byte 0
chrJ2:           .byte 0                  ;choix du joueur 2


;///////////////////////////////////////////Les constantes d'affichage////////////////////////////////////////

joueur2:          .ascii "JOUEUR 2\x00"                                            ;nomination du second joueur 
joueur1:         .ascii "JOUEUR 1\x00"                                             ;nomination du prémier joueur 
msgChois:          .ascii ", quel est votre choix? [r/p/c]\n\x00"                  ;message de sollicitation pour le choix du joueur
strMerr:         .ascii "\nErreur d'entrée! Programme terminé.\x00"                ;message d'erreur pour le choix 
strLigne:        .ascii "\n-----------------------------------------------\n\x00"  ;ligne de décoration
strTiret:        .ascii "---\x00"                                                  ;la pétite ligne de décoration
strP:            .ascii " Bienvenue au jeu de roche-papier-ciseau \x00 "           ; Message de présentation
strSol:          .ascii  "\nCombien de manches voulez-vous jouer?\n\x00"           ;Message de sollicitation
strMr:           .ascii "\nil reste \x00"
strMr2:          .ascii " manche(s) à jouer \x00"
strMnul:         .ascii "\nManche nulle...\n\x00"                                  ; Message pour une manche nulle 
strVmc:          .ascii " a gagné cette manche! Score: \x00"                       ; Message lorsque un joueur remporte une manche
strT:            .ascii "-\x00"                                                    ; tiret de séparation entre deux scores.
strMmc:          .ascii "  A GAGNÉ LE MATCH! FELICITATIONS!\x00"                   ;message de victoire de la fin du match 
strSfin:         .ascii "SCORE FINAL: \x00"                                        ;score final de la rencontre  
                 .end