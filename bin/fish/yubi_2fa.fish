function yubi_2fa --description "finds a 2fa code from a yubikey"
    # might be marginally faster to generate codes on demand, 
    # rather than generating all of the codes at once

    # get a service from ykman (yubikey) with fzf
    # set name (ykman oath list | fzf --preview '')
    # set l (string split " "  $name)
    # set code (ykman oath code $l[-1])
    # set l (string split " " $code)
    # set code $l[-1]

    # get a code from ykman (yubikey) with fzf
    set code (ykman oath code | fzf)
    set l (string split " " $code)
    set code $l[-1]
    
    # copy the code into the clipboard if not empty
    if not test -z "$code" 
        echo -n $code | pbcopy 
    end

    commandline -f repaint
end

