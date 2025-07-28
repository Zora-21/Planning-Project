(define (domain two_snowman)
    (:requirements
        :typing
        :negative-preconditions
        :equality
        :disjunctive-preconditions
        :conditional-effects
        :action-costs
        :fluents
        :numeric-fluents
    )

    (:types
        location direction ball - object
    )

    (:predicates
        (next ?from ?to - location ?dir - direction)
        (snow ?l - location)
        (occupancy ?l - location)
        (character_at ?l - location)
        (ball_at ?b - ball ?l - location)
        
        (snowman_at ?l - location)
        (ball_used_in_snowman ?b - ball)
    )

    (:functions
        (snowman_built) - number
        (total-cost) - number
        (ball_size ?b - ball) - number

        (balls_at ?l - location) - number
    )

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
; ACTION MOVE CHARACTER
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:action move_character
        :parameters
            (?from ?to - location ?dir - direction)
        :precondition
            (and
                (next ?from ?to ?dir)
                (character_at ?from)
                (not (occupancy ?to))
                (not (snowman_at ?to))
            )
        :effect
            (and
                (not (character_at ?from))
                (character_at ?to)
            )
    )

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
; ACTION MOVE BALL
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:action move_ball
        :parameters
            (?b - ball ?ppos ?from ?to - location ?dir - direction)
        :precondition
            (and
                (next ?ppos ?from ?dir)
                (next ?from ?to ?dir)
                (ball_at ?b ?from)
                (character_at ?ppos)

;-------------- La palla non deve essere già usata in un pupazzo
                (not (ball_used_in_snowman ?b))
                
;-------------- REGOLA DI IMPILAMENTO: Nella posizione di partenza, la palla da spostare può essere impilata solo su palle più grandi
                (forall (?o - ball)
                    (or
                        (= ?o ?b)
                        (not (ball_at ?o ?from))
                        (< (ball_size ?b) (ball_size ?o))
                    )
                )
                
;-------------- REGOLA DI MOVIMENTO: O la palla è sola nella posizione di partenza, oppure la posizione di arrivo deve essere libera
                (or
                    (forall (?o - ball)
                        (or
                            (= ?o ?b)
                            (not (ball_at ?o ?from))))
                    (forall (?o - ball)
                        (not (ball_at ?o ?to))
                    )
                )
                
;-------------- REGOLA DI IMPILAMENTO 2: Nella posizione di arrivo, la palla può essere impilata solo su palle più grandi
                (forall (?o - ball)
                    (or
                        (not (ball_at ?o ?to))
                        (< (ball_size ?b) (ball_size ?o))
                    )
                )
            )

        :effect
            (and
                (not (ball_at ?b ?from))
                (ball_at ?b ?to)

                (decrease (balls_at ?from) 1)
                (increase (balls_at ?to) 1)

;-------------- Se la posizione di arrivo non è occupata, la occupa
                (when
                    (not (occupancy ?to))
                    (occupancy ?to)
                )

;-------------- Se la posizione di partenza rimane senza palle, il personaggio si sposta lì e la posizione non è più occupata
                (when
                    (forall (?o - ball)
                        (or
                            (= ?o ?b)
                            (not (ball_at ?o ?from))))
                    (and
                        (not (character_at ?ppos))
                        (character_at ?from)
                        (not (occupancy ?from))
                    )
                )

                (not (snow ?to))
;-------------- Se c'è neve nella posizione di arrivo e la palla è piccola, aumenta di dimensione
                (when 
                    (and 
                        (snow ?to)
                        (< (ball_size ?b) 3)
                    )
                    (increase (ball_size ?b) 1)
                )

                (increase (total-cost) 1)
            )
    )

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
; ACTION BUILD SNOWMAN
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:action build_snowman
        :parameters
            (?l - location)
        :precondition
            (and
                (= (balls_at ?l) 3)
                (not (snowman_at ?l))
                ;----- Tutte le palle nella location non devono essere già usate in altri pupazzi
                (forall (?b - ball)
                    (or 
                        (not (ball_at ?b ?l))
                        (not (ball_used_in_snowman ?b))
                    )
                )
            )
        :effect
            (and
                (snowman_at ?l)
                (increase (snowman_built) 1)
                ;----- Marca tutte le palle nella location come usate
                (forall (?b - ball)
                    (when 
                        (ball_at ?b ?l)
                        (ball_used_in_snowman ?b)
                    )
                )
            )
    )
)