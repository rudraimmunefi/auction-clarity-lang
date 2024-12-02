(define-constant aucToken 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.aucToken)
(define-map stakedTokens { account: principal } { stakedAmount: uint })

(define-public (stakeToken (amount uint)) 
    (let ((balance (unwrap! (contract-call? aucToken get-balance tx-sender) (err "error fetching balance"))))
        (match (if (>= balance amount)
                   (ok (map-insert stakedTokens {account: tx-sender} {stakedAmount: amount}))
                   (err "not enough tokens"))
            success 
            (begin
                (print "Tokens staked successfully!")
                (ok success))
            error 
            (begin
                (print "Error staking tokens.")
                (err error))
        )
    )
)

(define-read-only (fetch-stakes (address principal)) 
    (map-get? stakedTokens {account: address})
)

