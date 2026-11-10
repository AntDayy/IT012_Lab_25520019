# Ho ten: Nguyen Thien An - MSSV: 25520019 - Muc dich: Tinh dien nang tung thang, tong ca nam va thang cao nhat
# Ke hoach dung thanh ghi:
# $s0: dia chi nen reading | $s1: dia chi nen usage | $s2: chi so i | $s3: so thang n = 12
# $s4: tong dien nang      | $s5: dien nang max     | $s6: thang co dien nang max

.data
m1:      .asciiz "Thang "
m2:      .asciiz ": "
mt:      .asciiz "Tong: "
mm:      .asciiz "Thang cao nhat: "
lp:      .asciiz " ("
rp:      .asciiz ")"
nl:      .asciiz "\n"
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         .word 2210, 2440, 2625, 2775, 2895, 2995
usage:   .space 48

.text
.globl main
main:
  la   $s0, reading     # $s0 = dia chi nen reading
  la   $s1, usage       # $s1 = dia chi nen usage
  addi $s2, $zero, 0    # i = 0
  addi $s3, $zero, 12   # n = 12 thang
  addi $s4, $zero, 0    # tong = 0
  addi $s5, $zero, -1   # max = -1
  addi $s6, $zero, 0    # thang max = 0

Loop:
  beq  $s2, $s3, Done   # thoat vong lap neu i == n
  
  # Tinh dia chi va doc reading[i], reading[i+1]
  sll  $t1, $s2, 2      # $t1 = 4 * i
  add  $t1, $t1, $s0    # $t1 = dia chi reading[i]
  lw   $t3, 0($t1)      # $t3 = reading[i]
  lw   $t4, 4($t1)      # $t4 = reading[i+1]
  
  # Tinh dien nang thang i+1 va luu vao usage[i]
  sub  $t5, $t4, $t3    # $t5 = reading[i+1] - reading[i]
  sll  $t2, $s2, 2      # $t2 = 4 * i
  add  $t2, $t2, $s1    # $t2 = dia chi usage[i]
  sw   $t5, 0($t2)      # usage[i] = $t5
  
  # In "Thang <i+1>: <dien nang>\n"
  li   $v0, 4
  la   $a0, m1
  syscall
  li   $v0, 1
  addi $a0, $s2, 1      # in thang i + 1
  syscall
  li   $v0, 4
  la   $a0, m2
  syscall
  li   $v0, 1
  addi $a0, $t5, 0      # in dien nang cua thang
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall
  
  # Cong don tong dien nang va cap nhat thang cao nhat
  add  $s4, $s4, $t5    # tong += $t5
  addi $t7, $s2, 1      # $t7 = thang hien tai (i + 1)
  slt  $t6, $s5, $t5    # $t6 = 1 neu max < dien nang thang nay
  beq  $t6, $zero, Skip # neu khong lon hon thi bo qua
  addi $s5, $t5, 0      # cap nhat dien nang max
  addi $s6, $t7, 0      # cap nhat thang max
  
Skip:
  addi $s2, $s2, 1      # i = i + 1
  j    Loop

Done:
  # In "Tong: <$s4>\n"
  li   $v0, 4
  la   $a0, mt
  syscall
  li   $v0, 1
  addi $a0, $s4, 0
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  # In "Thang cao nhat: <$s6> (<$s5>)\n"
  li   $v0, 4
  la   $a0, mm
  syscall
  li   $v0, 1
  addi $a0, $s6, 0
  syscall
  li   $v0, 4
  la   $a0, lp
  syscall
  li   $v0, 1
  addi $a0, $s5, 0
  syscall
  li   $v0, 4
  la   $a0, rp
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall
  
  li   $v0, 10          # ket thuc chuong trinh
  syscall
