class nodejs {

    package{"nodejs": ensure => installed}
    package{"nodejs-dev": ensure => installed}
    package{"npm": ensure => installed}

}

