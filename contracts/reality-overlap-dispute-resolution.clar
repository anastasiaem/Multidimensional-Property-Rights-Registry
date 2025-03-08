;; Reality Overlap Dispute Resolution Contract

(define-map disputes
  { id: uint }
  {
    asset-id: uint,
    claimant-1: principal,
    claimant-2: principal,
    status: (string-ascii 20)
  }
)

(define-map votes
  { dispute-id: uint, voter: principal }
  { vote-for: principal }
)

(define-data-var next-dispute-id uint u0)

(define-public (register-dispute (asset-id uint) (opposing-claimant principal))
  (let
    ((dispute-id (var-get next-dispute-id)))
    (var-set next-dispute-id (+ dispute-id u1))
    (ok (map-set disputes
      { id: dispute-id }
      {
        asset-id: asset-id,
        claimant-1: tx-sender,
        claimant-2: opposing-claimant,
        status: "open"
      }
    ))
  )
)

(define-public (vote-on-dispute (dispute-id uint) (vote-for principal))
  (ok (map-set votes
    { dispute-id: dispute-id, voter: tx-sender }
    { vote-for: vote-for }
  ))
)

(define-public (resolve-dispute (dispute-id uint))
  (match (map-get? disputes { id: dispute-id })
    dispute
      (ok (map-set disputes
        { id: dispute-id }
        (merge dispute { status: "resolved" })
      ))
    (err u404)
  )
)

(define-read-only (get-dispute (dispute-id uint))
  (map-get? disputes { id: dispute-id })
)

(define-read-only (get-vote (dispute-id uint) (voter principal))
  (map-get? votes { dispute-id: dispute-id, voter: voter })
)

