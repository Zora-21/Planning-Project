(define (problem chrisgur-adapted-for-coordinates)
    (:domain one_snowman_coordinates)

    (:objects
        ;; Oggetti del problema: 3 palle e 77 locazioni
        ball_0 ball_1 ball_2 - ball
        
        loc_1_1 loc_1_2 loc_1_3 loc_1_4 loc_1_5 loc_1_6 loc_1_7 loc_1_8 loc_1_9 loc_1_10
        loc_2_1 loc_2_3 loc_2_6 loc_2_7 loc_2_9
        loc_3_1 loc_3_3 loc_3_4 loc_3_5 loc_3_6 loc_3_9
        loc_4_1 loc_4_5 loc_4_6 loc_4_7 loc_4_8 loc_4_9
        loc_5_1 loc_5_2 loc_5_3 loc_5_5 loc_5_6 loc_5_9
        loc_6_1 loc_6_2 loc_6_3 loc_6_5 loc_6_7 loc_6_9
        loc_7_1 loc_7_3 loc_7_4 loc_7_5 loc_7_6 loc_7_7 loc_7_8 loc_7_9
        loc_8_1 loc_8_7 loc_8_8 loc_8_9 loc_8_10
        loc_9_1 loc_9_3 loc_9_4 loc_9_5 loc_9_7 loc_9_8 loc_9_10
        loc_10_1 loc_10_2 loc_10_3 loc_10_5 loc_10_6 loc_10_7 loc_10_8 loc_10_9 loc_10_10 - location
    )

    (:init
        ;; Inizializzazione dei valori numerici
        (= (total-cost) 0)
        (= (is_goal_achieved) 0)

        ;; Definizione delle coordinate per ogni locazione
        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_1_6) 1) (= (y-coord loc_1_6) 6)
        (= (x-coord loc_1_7) 1) (= (y-coord loc_1_7) 7)
        (= (x-coord loc_1_8) 1) (= (y-coord loc_1_8) 8)
        (= (x-coord loc_1_9) 1) (= (y-coord loc_1_9) 9)
        (= (x-coord loc_1_10) 1) (= (y-coord loc_1_10) 10)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_6) 2) (= (y-coord loc_2_6) 6)
        (= (x-coord loc_2_7) 2) (= (y-coord loc_2_7) 7)
        (= (x-coord loc_2_9) 2) (= (y-coord loc_2_9) 9)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_3_5) 3) (= (y-coord loc_3_5) 5)
        (= (x-coord loc_3_6) 3) (= (y-coord loc_3_6) 6)
        (= (x-coord loc_3_9) 3) (= (y-coord loc_3_9) 9)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_4_6) 4) (= (y-coord loc_4_6) 6)
        (= (x-coord loc_4_7) 4) (= (y-coord loc_4_7) 7)
        (= (x-coord loc_4_8) 4) (= (y-coord loc_4_8) 8)
        (= (x-coord loc_4_9) 4) (= (y-coord loc_4_9) 9)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)
        (= (x-coord loc_5_6) 5) (= (y-coord loc_5_6) 6)
        (= (x-coord loc_5_9) 5) (= (y-coord loc_5_9) 9)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_6_5) 6) (= (y-coord loc_6_5) 5)
        (= (x-coord loc_6_7) 6) (= (y-coord loc_6_7) 7)
        (= (x-coord loc_6_9) 6) (= (y-coord loc_6_9) 9)
        (= (x-coord loc_7_1) 7) (= (y-coord loc_7_1) 1)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_7_4) 7) (= (y-coord loc_7_4) 4)
        (= (x-coord loc_7_5) 7) (= (y-coord loc_7_5) 5)
        (= (x-coord loc_7_6) 7) (= (y-coord loc_7_6) 6)
        (= (x-coord loc_7_7) 7) (= (y-coord loc_7_7) 7)
        (= (x-coord loc_7_8) 7) (= (y-coord loc_7_8) 8)
        (= (x-coord loc_7_9) 7) (= (y-coord loc_7_9) 9)
        (= (x-coord loc_8_1) 8) (= (y-coord loc_8_1) 1)
        (= (x-coord loc_8_7) 8) (= (y-coord loc_8_7) 7)
        (= (x-coord loc_8_8) 8) (= (y-coord loc_8_8) 8)
        (= (x-coord loc_8_9) 8) (= (y-coord loc_8_9) 9)
        (= (x-coord loc_8_10) 8) (= (y-coord loc_8_10) 10)
        (= (x-coord loc_9_1) 9) (= (y-coord loc_9_1) 1)
        (= (x-coord loc_9_3) 9) (= (y-coord loc_9_3) 3)
        (= (x-coord loc_9_4) 9) (= (y-coord loc_9_4) 4)
        (= (x-coord loc_9_5) 9) (= (y-coord loc_9_5) 5)
        (= (x-coord loc_9_7) 9) (= (y-coord loc_9_7) 7)
        (= (x-coord loc_9_8) 9) (= (y-coord loc_9_8) 8)
        (= (x-coord loc_9_10) 9) (= (y-coord loc_9_10) 10)
        (= (x-coord loc_10_1) 10) (= (y-coord loc_10_1) 1)
        (= (x-coord loc_10_2) 10) (= (y-coord loc_10_2) 2)
        (= (x-coord loc_10_3) 10) (= (y-coord loc_10_3) 3)
        (= (x-coord loc_10_5) 10) (= (y-coord loc_10_5) 5)
        (= (x-coord loc_10_6) 10) (= (y-coord loc_10_6) 6)
        (= (x-coord loc_10_7) 10) (= (y-coord loc_10_7) 7)
        (= (x-coord loc_10_8) 10) (= (y-coord loc_10_8) 8)
        (= (x-coord loc_10_9) 10) (= (y-coord loc_10_9) 9)
        (= (x-coord loc_10_10) 10) (= (y-coord loc_10_10) 10)

        ;; Stato iniziale del mondo
        (character_at loc_6_1)
        
        (ball_at ball_0 loc_3_4)
        (= (ball_size ball_0) 1)

        (ball_at ball_1 loc_3_9)
        (= (ball_size ball_1) 1)

        (ball_at ball_2 loc_8_7)
        (= (ball_size ball_2) 1)

        (occupancy loc_3_4)
        (occupancy loc_3_9)
        (occupancy loc_8_7)

        (snow loc_1_1) (snow loc_1_2) (snow loc_1_3) (snow loc_1_4) (snow loc_1_5) (snow loc_1_6) (snow loc_1_7) (snow loc_1_8) (snow loc_1_9) (snow loc_1_10)
        (snow loc_2_1) (snow loc_2_3) (snow loc_2_6) (snow loc_2_7) (snow loc_2_9)
        (snow loc_3_1) (snow loc_3_3) (snow loc_3_5) (snow loc_3_6)
        (snow loc_4_1) (snow loc_4_5) (snow loc_4_6) (snow loc_4_7) (snow loc_4_8) (snow loc_4_9)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_3) (snow loc_5_5) (snow loc_5_6) (snow loc_5_9)
        (snow loc_6_2) (snow loc_6_3) (snow loc_6_5) (snow loc_6_7) (snow loc_6_9)
        (snow loc_7_1) (snow loc_7_3) (snow loc_7_4) (snow loc_7_5) (snow loc_7_6) (snow loc_7_7) (snow loc_7_8) (snow loc_7_9)
        (snow loc_8_1) (snow loc_8_8) (snow loc_8_9) (snow loc_8_10)
        (snow loc_9_1) (snow loc_9_3) (snow loc_9_4) (snow loc_9_5) (snow loc_9_7) (snow loc_9_8) (snow loc_9_10)
        (snow loc_10_1) (snow loc_10_2) (snow loc_10_3) (snow loc_10_5) (snow loc_10_6) (snow loc_10_7) (snow loc_10_8) (snow loc_10_9) (snow loc_10_10)
    )

    (:goal
        (and
            ;; L'obiettivo è che la condizione di goal definita nell'azione apposita sia soddisfatta
            (= (is_goal_achieved) 1)
        )
    )

    (:metric minimize (total-cost))
)