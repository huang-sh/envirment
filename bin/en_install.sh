process_text(){
    if grep -lI "$old_dir" $1 >/dev/null; then
        sed -i "s+$old_dir+$ODP_ROOT+g" $1
    fi
}
process_binary() {
    local patchelf=$ODP_ROOT/bin/patchelf
    local new_linker=$ODP_LIB_PATH/ld-linux-x86-64.so.2
    local old_linker=`$patchelf --print-interpreter $1`
    if [[ $old_linker == $new_linker ]]; then
        return;
    fi
    return;
    $patchelf --set-interpreter $new_linker $1
    binary_installed="$binary_installed `basename $1`"
}
apply_files() {
    local param=$1
    for dir in ${param[*]}; do
        dir=$ODP_ROOT/$dir
        if [[ -d $dir ]]; then
            local files=`find $dir -type f`
        elif [[ -f $dir ]]; then
            $2 $dir
        fi
    done
}

init_env() {
    ODP_ROOT=$(readlink -f `dirname $BASE_SOURCE[0]`/..)
    ODP_LIB_PATH=$ODP_ROOT/lib/gcc-4.9.0
}
install() {
    binary_installed=''
    package_installed=''
    local configs=`ls $ODP_ROOT/bin/config/*/config.sh`

    for config in ${configs[*]}; do
        local package=$(basename `dirname $config`)
        local binary_files=
        local text_files=
        local serialized_files=
        local macro_files=
        old_dir=
        macros=
        source $config
        apply_files "${binary_files[*]}" process_binary
        if [[ $old_dir == $ODP_ROOT ]]; then
            continue;
        fi
        apply_files "${text_files[*]}" process_text
    done
}

init_env
install
