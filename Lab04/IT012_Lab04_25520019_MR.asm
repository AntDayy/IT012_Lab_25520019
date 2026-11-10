# Ho ten: Nguyen Thien An - MSSV: 25520019 - Muc dich: Tinh dien nang va dem so thang theo tung bac gia
# Ke hoach thanh ghi:
# $s0: dia chi nen reading | $s1: dia chi nen usage | $s7: dia chi nen cnt
# $s2: chi so i            | $s3: n = 12            | $s4: tong | $s5: max | $s6: thang max
.data
m1:      .asciiz "Thang "
m2:      .asciiz ": "
mt:      .asciiz "Tong: "
mm:      .asciiz "Thang cao nhat: "
mb:      .asciiz "Bac "
lp:      .asciiz " ("
rp:      .asciiz ")"
nl:      .asciiz "\n"
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         .word 2210, 2440, 2625, 2775, 2895, 2995
usage:   .space 48
cnt:     .word 0, 0, 0, 0

.text
.globl main
main:
  la   $s0, reading
  la   $s1, usage
  addi $s2, $zero, 0
  addi $s3, $zero, 12
  addi $s4, $zero, 0
  addi $s5, $zero, -1
  addi $s6, $zero, 0

Loop1:
  beq  $s2, $s3, Done1
  sll  $t1, $s2, 2
  add  $t2, $s0, $t1
  lw   $t3, 0($t2)
  lw   $t4, 4($t2)
  sub  $t5, $t4, $t3
  add  $t6, $s1, $t1
  sw   $t5, 0($t6)

  add  $s4, $s4, $t5
  addi $t7, $s2, 1
  slt  $t1, $s5, $t5
  beq  $t1, $zero, Skip
  add  $s5, $t5, $zero
  add  $s6, $t7, $zero

Skip:
  li   $v0, 4
  la   $a0, m1
  syscall
  li   $v0, 1
  add  $a0, $t7, $zero
  syscall
  li   $v0, 4
  la   $a0, m2
  syscall
  li   $v0, 1
  add  $a0, $t5, $zero
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  addi $s2, $s2, 1
  j    Loop1

Done1:
  li   $v0, 4
  la   $a0, mt
  syscall
  li   $v0, 1
  add  $a0, $s4, $zero
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  li   $v0, 4
  la   $a0, mm
  syscall
  li   $v0, 1
  add  $a0, $s6, $zero
  syscall
  li   $v0, 4
  la   $a0, lp
  syscall
  li   $v0, 1
  add  $a0, $s5, $zero
  syscall
  li   $v0, 4
  la   $a0, rp
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  # --- PHAN MO RONG: Duyet usage va dem so thang theo bac gia ---
  la   $s7, cnt         # $s7 = dia chi nen mang cnt
  addi $s2, $zero, 0    # i = 0

LoopCnt:
  beq  $s2, $s3, PrintCnt
  sll  $t1, $s2, 2
  add  $t2, $s1, $t1
  lw   $t0, 0($t2)      # $t0 = usage[i]

  slti $t3, $t0, 101
  bne  $t3, $zero, CntB1
  slti $t3, $t0, 151
  bne  $t3, $zero, CntB2
  slti $t3, $t0, 201
  bne  $t3, $zero, CntB3
  addi $t4, $zero, 3    # chi so bac 4 (index 3)
  j    UpdateCnt

CntB1:
  addi $t4, $zero, 0    # chi so bac 1 (index 0)
  j    UpdateCnt
CntB2:
  addi $t4, $zero, 1    # chi so bac 2 (index 1)
  j    UpdateCnt
CntB3:
  addi $t4, $zero, 2    # chi so bac 3 (index 2)

UpdateCnt:
  sll  $t4, $t4, 2      # offset = index * 4
  add  $t4, $s7, $t4    # dia chi cnt[index]
  lw   $t5, 0($t4)      # doc cnt[index]
  addi $t5, $t5, 1      # tang them 1
  sw   $t5, 0($t4)      # luu lai cnt[index]

  addi $s2, $s2, 1
  j    LoopCnt

PrintCnt:
  addi $s2, $zero, 0    # k = 0..3
  addi $s3, $zero, 4
LoopPrintCnt:
  beq  $s2, $s3, ExitMR
  li   $v0, 4
  la   $a0, mb
  syscall

  addi $a0, $s2, 1      # in k + 1 (1..4)
  li   $v0, 1
  syscall

  li   $v0, 4
  la   $a0, m2
  syscall

  sll  $t1, $s2, 2
  add  $t2, $s7, $t1
  lw   $a0, 0($t2)      # in cnt[k]
  li   $v0, 1
  syscall

  li   $v0, 4
  la   $a0, nl
  syscall

  addi $s2, $s2, 1
  j    LoopPrintCnt

ExitMR:
  li   $v0, 10
  syscall