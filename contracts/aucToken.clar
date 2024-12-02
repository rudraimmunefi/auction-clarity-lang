(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-constant owner tx-sender)
(define-constant err-owner (err u1))
(define-constant err-not-owner (err u2))

(define-fungible-token auc-token u1000000)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34)))) 
    (begin
        (try! (ft-transfer? auc-token amount sender recipient))
        (match memo print-var (print print-var) 0x)
        (ok true)
    )
)

(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq contract-caller owner) err-owner)
        (ft-mint? auc-token amount recipient)
    )
)

(define-public (get-name )
    (ok "auc Token")
)

(define-public (get-symbol) 
    (ok "AUC")
)

(define-read-only (get-decimals)
    (ok u6)
)

(define-public (get-balance (address principal))
    (ok (ft-get-balance auc-token address ) )
)

(define-public (get-total-supply)
    (ok (ft-get-supply auc-token))
)

(define-read-only (get-token-uri) 
    (ok none)
)