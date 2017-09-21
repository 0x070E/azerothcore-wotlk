function inst_configureOS() {
    echo "Platform: $OSTYPE"
    case "$OSTYPE" in
        solaris*) echo "Solaris is not supported yet" ;;
        darwin*)  source "$AC_PATH_INSTALLER/includes/os_configs/osx.sh" ;;  
        linux*)   
            # TODO: implement different configurations by distro
            source "$AC_PATH_INSTALLER/includes/os_configs/linux.sh"
        ;;
        bsd*)     echo "BSD is not supported yet" ;;
        msys*)    source "$AC_PATH_INSTALLER/includes/os_configs/windows.sh" ;;
        *)        echo "This platform is not supported" ;;
    esac
}

function inst_updateRepo() {
    git pull origin $(git rev-parse --abbrev-ref HEAD)
}

function inst_resetRepo() {
    git reset --hard $(git rev-parse --abbrev-ref HEAD)
    git clean -f
}

function inst_compile() {
    comp_configure
    comp_build
}

function inst_cleanCompile() {
    comp_clean
    inst_compile
}

function inst_assembleDb {
    dbasm_import true true true
}

function inst_allInOne() {
    inst_configureOS
    inst_updateRepo
    inst_compile
    inst_assembleDb
}

function inst_module_search {
    search=""
    if [ -z "$1" ]; then
        echo "Type what to search or leave blank for full list"
        read -p "Insert name: " res

        search="+$res"
    fi
    echo "Searching ..."
    echo "";

    for i in `curl -s "https://api.github.com/search/repositories?q=org%3Aazerothcore${search}+fork%3Atrue+topic%3Acore-module+sort%3Astars&type=" | grep \"name\" | cut -d ':' -f 2-3|tr -d '",'`; do
        echo "-> $i"; 
    done

    echo "";
    echo "";
}

function inst_module_install {
    if [ -z "$1" ]; then
        echo "Type the name of the module to install"
        read -p "Insert name: " res
    fi

    git clone "https://github.com/azerothcore/$res" "modules/$res" && echo "Done, please re-run compiling and db assembly. Read instruction on module repository for more information"

    echo "";
    echo "";
}

function inst_module_update {
    if [ -z "$1" ]; then
        echo "Type the name of the module to update"
        read -p "Insert name: " res
    fi

    cd "modules/$res"

    #git reset --hard master
    #git clean -f
    git pull origin master && echo "Done"

    cd "../../"

    echo "";
    echo "";
}

function inst_module_remove {
    if [ -z "$1" ]; then
        echo "Type the name of the module to remove"
        read -p "Insert name: " res
    fi

    rm -rf "modules/$res" && echo "Done"

    echo "";
    echo "";
}