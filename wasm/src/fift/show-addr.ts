export const showAddr = `#!/usr/bin/fift -s
"TonUtil.fif" include

{ ."usage: " $0 type ." <filename-base>" cr
  ."Shows the address of a simple wallet created by new-wallet.fif, with address in <filename-base>.addr "
  ."and private key in file <filename-base>.pk" cr 1 halt
} : usage
$# 1 > ' usage if
1 :$1..n
$1 "new-wallet" replace-if-null =: file-base

file-base +".addr" dup ."Loading wallet address from " type cr file>B 32 B|
dup Blen { 32 B>i@ } { drop Basechain } cond constant wallet_wc
256 B>u@ dup constant wallet_addr
."Source wallet address = " wallet_wc swap 2dup .addr cr
."Non-bounceable address (for init only): " 2dup 7 .Addr cr
."Bounceable address (for later access): " 6 .Addr cr

file-base +".pk" dup file-exists? {
  dup file>B dup Blen 32 <> abort"Private key must be exactly 32 bytes long"
  =: wallet_pk ."Private key available in file " type cr
} { ."Private key file " type ." not found" cr } cond
file-base +".pk" load-generate-keypair drop file-base +".pub" B>file
`
