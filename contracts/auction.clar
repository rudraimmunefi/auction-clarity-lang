(define-map stakedTokens { account: principal } { stakedAmount: uint })
(define-constant owner tx-sender)

(define-public (stakeToken (amount uint)) 
    (let ((balance (unwrap! (contract-call? .aucToken get-balance tx-sender) (err "error fetching balance"))))
        (if (>= balance amount)
            (begin
                (map-insert stakedTokens {account: tx-sender} {stakedAmount: amount})
                (unwrap! (contract-call? .aucToken transfer amount tx-sender owner (some 0x)) (err "error transferring tokens"))
                (ok true)
            )
            (begin
                (err "not enough tokens")
            )
        )
    )
)

(define-read-only (fetch-stakes (address principal)) 
    (map-get? stakedTokens {account: address})
)

