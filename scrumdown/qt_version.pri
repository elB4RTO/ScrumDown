
lessThan(QT_VERSION, 6.7.2) {
    error("Qt 6.7.2 or above is required. Detected: $$QT_VERSION")
}

