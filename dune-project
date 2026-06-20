(lang dune 3.0)

(name gamblers_ruin)

(generate_opam_files true)

(source
 (github bsmuga/gamblers-ruin))

(authors "bsmuga")

(maintainers "bsmuga")

(license MIT)

(package
 (name gamblers_ruin)
 (synopsis "Gambler's ruin: numerical engine, closed forms, and simulation")
 (description
  "The gambler's-ruin problem solved three independent ways: a numerical engine\n(absorbing Markov chain reduced to a tridiagonal system, solved with the Thomas\nalgorithm), the closed-form formulas, and a seeded Monte-Carlo simulation. The\nthree routes cross-check one another.")
 (depends
  (ocaml
   (>= 5.1))
  dune
  (alcotest :with-test)
  (qcheck-alcotest :with-test)))
