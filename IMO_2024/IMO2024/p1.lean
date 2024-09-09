import Mathlib.Algebra.EuclideanDomain.Basic
import Mathlib.Algebra.EuclideanDomain.Int
import Mathlib.Analysis.RCLike.Basic
import Mathlib.Tactic.Have

open scoped BigOperators

/--
Determine all real numbers $\alpha$ such that, for every positive integer $n$, the integer
$$
\lfloor \alpha\rfloor + \lfloor2\alpha\rfloor + \cdots + \lfloor n\alpha\rfloor
$$
is a multiple of $n$.
(Note that $\lfloor z\rfloor$ denotes the greatest integer less than or equal to $z$.
For example, $\lfloor-\pi\rfloor = -4$ and $\lfloor2\rfloor = \lfloor2.9\rfloor = 2$.)

Solution: $\alpha$ is an even integer.
-/
theorem imo_2024_p1 :
   {(α : ℝ) | ∀ (n : ℕ), 0 < n → (n : ℤ) ∣ (∑ i in Finset.Icc 1 n, ⌊i * α⌋)}
   = {α : ℝ | ∃ k : ℤ, Even k ∧ α = k} := by
  rw [(Set.Subset.antisymm_iff ), (Set.subset_def), ]
  /- We introduce a variable that will be used
     in the second part of the proof (the hard direction),
     namely the integer `l` such that `2l = ⌊α⌋ + ⌊2α⌋`
     (this comes from the given divisibility condition with `n = 2`). -/
  existsλx L=>(L 2 two_pos).rec λl Y=>?_
  useλy . x=>y.rec λS p=>?_
  · /- We start by showing that every `α` of the form `2k` works.
       In this case, the sum simplifies to `kn(n+1)`),
       which is clearly divisible by `n`. -/
    simp_all[λL:ℕ=>(by norm_num[Int.floor_eq_iff]:⌊(L:ℝ)*S⌋=L* S )]
    rw[p.2,Int.dvd_iff_emod_eq_zero,Nat.lt_iff_add_one_le,<-Finset.sum_mul,←Nat.cast_sum, S.even_iff, ←Nat.Ico_succ_right,@ .((( Finset.sum_Ico_eq_sum_range))),Finset.sum_add_distrib ]at*
    simp_all[Finset.sum_range_id]
    exact dvd_trans ⟨2+((_:ℕ)-1),by linarith[((‹ℕ›:Int)*(‹Nat›-1)).ediv_mul_cancel$ Int.prime_two.dvd_mul.2<|by ·omega]⟩ ↑↑(mul_dvd_mul_left @_ (p))
  /- Now let's prove the converse, i.e. that every `α` in the LHS
     is an even integer. We claim for all such `α` and `n ∈ ℕ`, we have
     `⌊(n+1)*α⌋ = ⌊α⌋+2n(l-⌊α⌋)`. -/
  suffices : ∀ (n : ℕ),⌊(n+1)*x⌋ =⌊ x⌋+2 * ↑ (n : ℕ) * (l-(⌊(x)⌋))
  · /- Let's assume for now that the claim is true,
       and see how this is enough to finish our proof. -/
    zify[mul_comm,Int.floor_eq_iff] at this
    -- We'll show that `α = 2(l-⌊α⌋)`, which is obviously even.
    use(l-⌊x⌋)*2
    norm_num
    -- To do so, it suffices to show `α ≤ 2(l-⌊α⌋)` and `α ≥ 2(l-⌊α⌋)`.
    apply@le_antisymm
    /- To prove the first inequality, notice that if `α > 2(l-⌊α⌋)` then
       there exists an integer `N > 0` such that `N ≥ 1/(α - 2(l -⌊α⌋))`.
       By our assumed claim (with `n = N`), we have
       `⌊α⌋ + 2(l-⌊α⌋)N + 1 > (N+1)α`, i.e.
       `⌊α⌋ + (2(l-⌊α⌋) - α)N + 1 > α`,
       and this implies `⌊α⌋ > α`; contradiction. -/
    use not_lt.1 (by cases exists_nat_ge (1/(x-_)) with|_ N =>nlinarith[ one_div_mul_cancel $ sub_ne_zero.2 ·.ne',9,Int.floor_le x, this N])
   /- Similarly, if `α < 2(l-⌊α⌋)` then we can find a positive natural `N`
      such that `N ≥ 1/(2(l-⌊α⌋) - α)`.
      By our claim (with `n = N`), we have
      `(N+1)α ≥ ⌊α⌋ + 2(l-⌊α⌋)N`, i.e.
      `α ≥ ⌊α⌋ + (2(l-⌊α⌋) - α)N`,
      and this implies `a ≥ ⌊α⌋ + 1`; contradiction. -/
    use not_lt.1 (by cases exists_nat_ge (1/_:ℝ)with|_ A=>nlinarith[Int.lt_floor_add_one x,one_div_mul_cancel$ sub_ne_zero.2 ·.ne',this A])
  /- Now all that's left to do is to prove our claim
     `⌊(n + 1)α⌋ = ⌊α⌋ + 2n(l - ⌊α⌋)`. -/
  intro
  -- We argue by strong induction on `n`.
  induction‹_› using@Nat.strongInductionOn
  -- By our hypothesis on `α`, we know that `(n+1) | ∑_{i=1}^(n+1) ⌊iα⌋`
  specialize L$ ‹_›+1
  simp_all[add_comm,mul_assoc,Int.floor_eq_iff,<-Nat.Ico_succ_right, add_mul,(Finset.range_succ), Finset.sum_Ico_eq_sum_range]
  revert‹ℕ›
  /- Thus, there exists `c` such that
     `(n+1)*c = ∑_{i=1}^{n+1} ⌊iα⌋ = ⌊nα+α⌋ + ∑_{i=1}^n ⌊iα⌋`. -/
  rintro A B@c
  simp_all[ Finset.mem_range.mp _,←eq_sub_iff_add_eq',Int.floor_eq_iff]
  /- By the inductive hypothesis,
     `∑_{i=0}^{n-1}, ⌊α+iα⌋ = ∑_{i=0}^{n-1}, ⌊α⌋+2*i*(l-⌊α⌋)`. -/
  suffices:∑d in .range A,⌊x+d*x⌋=∑Q in .range A,(⌊x⌋+2*(Q * (l-.floor x)))
  · suffices:∑d in ( .range A),(((d)):ℤ) =A * ( A-1)/2
    · have:(A : ℤ) * (A-1)%2=0
      · cases@Int.emod_two_eq A with|_ B=>norm_num[B,Int.sub_emod,Int.mul_emod]
      norm_num at*
      norm_num[ Finset.sum_add_distrib,<-Finset.sum_mul, ←Finset.mul_sum _ _] at*
      rw[eq_sub_iff_add_eq]at*
      /- Combined with
         `∑_{i=0}^{n-1},⌊iα+α⌋ = (n+1)c - ⌊nα+α⌋`,
         we have `⌊nα+α⌋ = (n+1)c - n⌊α⌋ - n(n-1)(l-⌊α⌋)`, so
         `⌊nα+α⌋ ≥ (n+1)c - n⌊α⌋ - n(n-1)(l-⌊α⌋)`
         and
         `⌊nα+α⌋ < (n+1)c - n⌊α⌋ - n(n-1)(l-⌊α⌋) + 1`.
         Also, since `2*l = ⌊α⌋ + ⌊2α⌋`, we have
         `2α+⌊α⌋-1 < 2*l ≤ 2α+⌊α⌋.`-/
      zify[←mul_assoc, this,←eq_sub_iff_add_eq',‹_ =(@ _) /@_›,Int.floor_eq_iff] at *
      zify[*]at*
      -- We will now show that `c = n*(l-⌊α⌋) + ⌊α⌋`.
      cases S5:lt_or_ge c (A * (l-.floor ↑x)+⌊x⌋ + 1)
      · simp_all
        have:(c+1:ℝ)<=A*(l-⌊x⌋)+⌊x⌋+1:=by norm_cast
        simp_all
        cases this.eq_or_lt
        · /- For if `c = n*(l-⌊α⌋) + ⌊α⌋`, then
             ```
             ⌊(n+1)α⌋ = (n+1)c - n⌊α⌋ - n(n-1)(l-⌊α⌋)
             = (n+1)(n(l - ⌊α⌋) + ⌊α⌋) - n⌊α⌋ - n(n-1)(l-⌊α⌋)
             = 2n(l-⌊α⌋) + ⌊α⌋
             ```
             as desired. -/
           repeat use by nlinarith
        /- Now, we show `c = n*(l-⌊α⌋) + ⌊α⌋` via contradiction
           split into two cases. First suppose `c ≤ n(l - ⌊α⌋) + ⌊α⌋ - 1`.
           ```
           (n+1)α < (n+1)c - n⌊α⌋ - n(n-1)(l-⌊α⌋) + 1
           ≤ (n+1)(n(l-⌊α⌋) + ⌊α⌋ - 1) - n⌊α⌋ - n(n-1)(l-⌊α⌋) + 1
           = 2n(l-⌊α⌋) + ⌊α⌋ - n
           = 2ln - 2n⌊α⌋ + ⌊α⌋ - n
           ≤ (2α+⌊α⌋)n - 2n⌊α⌋ + ⌊α⌋ - n
           = nα + n(α-⌊α⌋-1) + ⌊α⌋
           n + α.
           ```
           contradiction. -/
        nlinarith[(by norm_cast at* :(A*(l -⌊x⌋):ℝ)+⌊(x)⌋ >=(c)+01),9,Int.add_emod ↑5,Int.floor_le (@x : ℝ),Int.lt_floor_add_one (x:)]
      /- Next, suppose `c ≥ n(l - ⌊α⌋) + ⌊α⌋ + 1`.
         ```
         (n+1)α ≥ (n+1)c - n⌊α⌋ - n(n-1)(l-⌊α⌋)
         ≥ (n+1)(n(l-⌊α⌋) + ⌊α⌋ + 1) - n⌊α⌋ - n(n-1)(l-⌊α⌋)
         = 2n(l-⌊α⌋) + ⌊α⌋ + n + 1
         = 2ln - 2n⌊α⌋ + ⌊α⌋ + n + 1
         > (2α+⌊α⌋-1)n - 2n⌊α⌋ + ⌊α⌋ + n + 1
         = nα + n(α-⌊α⌋) + ⌊α⌋ + 1
         > n + α
         ```
         contradiction. -/
      simp_all
      nlinarith[(by norm_cast:(c:ℝ)>=A*(l-⌊_⌋)+⌊_⌋+1),Int.floor_le x,Int.lt_floor_add_one x]
    rw [←Nat.cast_sum, mul_sub, Finset.sum_range_id]
    cases A with|_=>norm_num[mul_add]
  use Finset.sum_congr rfl<|by simp_all[add_comm,Int.floor_eq_iff]

#print axioms imo_2024_p1
