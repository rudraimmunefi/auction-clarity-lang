(define-map stakedTokens { account: principal } { stakedAmount: uint } )
(define-map rewards { account: principal } { reward: (tuple (accumulated_rewards uint) (last_withdrawal_time uint)) })
(define-constant owner tx-sender)

(define-public (stakeToken (amount uint)) 
    (let ((balance (unwrap! (contract-call? .aucToken get-balance tx-sender) (err "error fetching balance"))))
        (if (>= balance amount)
            (begin
                (map-insert stakedTokens {account: tx-sender} {stakedAmount: amount})
                (unwrap! (contract-call? .aucToken transfer amount tx-sender owner (some 0x)) (err "error transferring tokens"))
                (ok true)
            )
            (err "not enough tokens")
        )
    )
)

(define-read-only (fetch-stakes (address principal)) 
    (map-get? stakedTokens {account: address})
)

(define-public (withdraw) 
    (let ((stake (unwrap! (map-get? stakedTokens {account : tx-sender}) (err "error fetching stakes")))) 
        (let ((stakedAmount (get stakedAmount stake)))
            (unwrap! (contract-call? .aucToken transfer stakedAmount owner tx-sender (some 0x)) (err "Token transfer failed"))
            (map-delete stakedTokens {account: tx-sender})
            (ok true)
        )
    )
)

(define-read-only (get-owner) 
    (begin 
        (ok owner)
    )
)

