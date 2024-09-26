#ifndef SCRUMDOWN_ENSEMBLE_H
#define SCRUMDOWN_ENSEMBLE_H

#include <QColor>
#include <QObject>

#define GNOME   'g'
#define KDE     'k'
#define WINDOWS 'w'

class Theme
{
    Q_GADGET

    Q_PROPERTY(QColor light_background MEMBER _light_background CONSTANT)
    Q_PROPERTY(QColor light_background_alt MEMBER _light_background_alt CONSTANT)
    Q_PROPERTY(QColor light_text MEMBER _light_text CONSTANT)
    Q_PROPERTY(QColor light_button_static MEMBER _light_button_static CONSTANT)
    Q_PROPERTY(QColor light_button_hovered MEMBER _light_button_hovered CONSTANT)
    Q_PROPERTY(QColor light_button_down MEMBER _light_button_down CONSTANT)
    Q_PROPERTY(QColor light_timer_text MEMBER _light_timer_text CONSTANT)
    Q_PROPERTY(QColor light_timer_expiring MEMBER _light_timer_expiring CONSTANT)
    Q_PROPERTY(QColor light_timer_blinking MEMBER _light_timer_blinking CONSTANT)
    Q_PROPERTY(QColor light_timer_expired MEMBER _light_timer_expired CONSTANT)

    Q_PROPERTY(QColor dark_background MEMBER _dark_background CONSTANT)
    Q_PROPERTY(QColor dark_background_alt MEMBER _dark_background_alt CONSTANT)
    Q_PROPERTY(QColor dark_text MEMBER _dark_text CONSTANT)
    Q_PROPERTY(QColor dark_button_static MEMBER _dark_button_static CONSTANT)
    Q_PROPERTY(QColor dark_button_hovered MEMBER _dark_button_hovered CONSTANT)
    Q_PROPERTY(QColor dark_button_down MEMBER _dark_button_down CONSTANT)
    Q_PROPERTY(QColor dark_timer_text MEMBER _dark_timer_text CONSTANT)
    Q_PROPERTY(QColor dark_timer_expiring MEMBER _dark_timer_expiring CONSTANT)
    Q_PROPERTY(QColor dark_timer_blinking MEMBER _dark_timer_blinking CONSTANT)
    Q_PROPERTY(QColor dark_timer_expired MEMBER _dark_timer_expired CONSTANT)

    Q_PROPERTY(QColor pin_border MEMBER _pin_border CONSTANT)

public:
    Theme() = default;
    Theme(const Theme&) noexcept {}
    Theme& operator=(const Theme&) noexcept { return *this; }

private:
    const QColor _light_background{229, 229, 229};
    const QColor _light_background_alt{212, 212, 212};
    const QColor _light_text{55, 55, 55};
    const QColor _light_button_static{219, 219, 219};
    const QColor _light_button_hovered{212, 212, 212};
    const QColor _light_button_down{205, 205, 205};
    const QColor _light_timer_text{0, 0, 0};
    const QColor _light_timer_expiring{214, 0, 104};
    const QColor _light_timer_blinking{255, 59, 40};
    const QColor _light_timer_expired{196, 133, 158};

    const QColor _dark_background{55, 55, 55};
    const QColor _dark_background_alt{72, 72, 72};
    const QColor _dark_text{229, 229, 229};
    const QColor _dark_button_static{64, 64, 64};
    const QColor _dark_button_hovered{72, 72, 72};
    const QColor _dark_button_down{86, 86, 86};
    const QColor _dark_timer_text{255, 255, 255};
    const QColor _dark_timer_expiring{255, 37, 0};
    const QColor _dark_timer_blinking{255, 127, 55};
    const QColor _dark_timer_expired{158, 79, 66};

    const QColor _pin_border{0, 181, 255};

};

struct Settings
{
    Q_GADGET

    Q_PROPERTY(int themes_border_width MEMBER _themes_border_width CONSTANT)
    Q_PROPERTY(int timer_top_padding MEMBER _timer_top_padding CONSTANT)

public:
    Settings() = default;
    Settings(const Settings&) noexcept {}
    Settings& operator=(const Settings&) noexcept { return *this; }

private:
#ifndef DESKTOP_ENVIRONMENT
    const int _themes_border_width{10};
    const int _timer_top_padding{0};
#elif DESKTOP_ENVIRONMENT == GNOME
    const int _themes_border_width{7};
    const int _timer_top_padding{7};
#elif DESKTOP_ENVIRONMENT == KDE
    const int _themes_border_width{8};
    const int _timer_top_padding{0};
#else
    static_assert(false, "Unsupported DesktopEnvironment");
#endif
};

class Ensemble : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Theme theme MEMBER _theme CONSTANT)
    Q_PROPERTY(Settings settings MEMBER _settings CONSTANT)

public:
    explicit Ensemble(QObject * parent = nullptr) : QObject(parent) {}

private:
    const Theme _theme{};
    const Settings _settings{};

};

#endif // SCRUMDOWN_ENSEMBLE_H
