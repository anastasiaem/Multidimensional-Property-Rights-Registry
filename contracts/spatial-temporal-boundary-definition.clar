;; Spatial-temporal Boundary Definition Contract

(define-map boundaries
  { id: uint }
  {
    asset-id: uint,
    coordinates: (string-utf8 64),
    time-start: uint,
    time-end: uint
  }
)

(define-data-var next-boundary-id uint u0)

(define-public (define-boundary (asset-id uint) (coordinates (string-utf8 64)) (time-start uint) (time-end uint))
  (let
    ((boundary-id (var-get next-boundary-id)))
    (var-set next-boundary-id (+ boundary-id u1))
    (ok (map-set boundaries
      { id: boundary-id }
      {
        asset-id: asset-id,
        coordinates: coordinates,
        time-start: time-start,
        time-end: time-end
      }
    ))
  )
)

(define-public (update-boundary (boundary-id uint) (coordinates (string-utf8 64)))
  (match (map-get? boundaries { id: boundary-id })
    boundary
      (ok (map-set boundaries
        { id: boundary-id }
        (merge boundary { coordinates: coordinates })
      ))
    (err u404)
  )
)

(define-read-only (get-boundary (boundary-id uint))
  (map-get? boundaries { id: boundary-id })
)

