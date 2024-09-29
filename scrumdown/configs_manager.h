#ifndef SCRUMDOWN_CONFIGS_MANAGER_H
#define SCRUMDOWN_CONFIGS_MANAGER_H

#include <QDir>
#include <QFile>
#include <QRect>
#include <QStandardPaths>

#include <iostream>

#if defined( Q_OS_MACOS )
#  define SET_CONFIGS_PATH() configs_path = home_path + "/Lybrary/Preferences/ScrumDown/scrumdown.conf";
#elif defined( Q_OS_WINDOWS )
#  define SET_CONFIGS_PATH() configs_path = home_path + "/AppData/Local/ScrumDown/scrumdown.conf";
#elif defined( Q_OS_LINUX ) || defined( Q_OS_BSD4 )
#  define SET_CONFIGS_PATH() configs_path = home_path + "/.config/ScrumDown/scrumdown.conf";
#else
#  error "System not supported"
#endif

class ConfigsManager : public QObject
{
    Q_OBJECT

public:
    explicit ConfigsManager(QObject * parent = nullptr)
        : QObject(parent), geometry{0,0,300,200}, theme{QLatin1String("light")}, time{180}, pin_mode{false}
    {
        QString home_path{QStandardPaths::locate(QStandardPaths::HomeLocation, "", QStandardPaths::LocateDirectory)};
        while (home_path.endsWith(QChar('/')))
        {
            home_path.chop(1);
        }
        SET_CONFIGS_PATH()
    }

    Q_INVOKABLE bool readConfigs() noexcept
    {
        if (!checkConfigsDir(false))
        {
            return false;
        }

        QFile file{configs_path};
        if (!file.open(QIODevice::ReadOnly))
        {
            std::cerr << "ScrumDown: failed to open configuration file" << std::endl;
            return false;
        }

        const auto values{QTextStream(&file).readAll().trimmed().split(QChar(','))};
        if (values.size() != 8)
        {
            std::cerr << "ScrumDown: invalid amount of configuration values" << std::endl;
        }
        else
        {
            parseConfigs(values);
        }

        file.close();
        return true;
    }

    Q_INVOKABLE bool writeConfigs() const noexcept
    {
        if (!checkConfigsDir(true))
        {
            return false;
        }

        QFile file{configs_path};
        if (!file.open(QIODevice::WriteOnly))
        {
            std::cerr << "ScrumDown: failed to open configuration file" << std::endl;
            return false;
        }

        QTextStream(&file) << stringifyConfigs();

        file.close();
        return true;
    }

    Q_INVOKABLE bool getMaximization() const noexcept
    {
        return maximized;
    }

    Q_INVOKABLE void setMaximization(const bool new_maximized) noexcept
    {
        maximized = new_maximized;
    }

    Q_INVOKABLE QRect getGeometry() const noexcept
    {
        return geometry;
    }

    Q_INVOKABLE void setGeometry(const int new_x, const int new_y, const int new_width, const int new_height) noexcept
    {
        geometry.setX(new_x);
        geometry.setY(new_y);
        geometry.setWidth(new_width);
        geometry.setHeight(new_height);
    }

    Q_INVOKABLE QString getTheme() const noexcept
    {
        return theme;
    }

    Q_INVOKABLE void setTheme(const QString new_theme) noexcept
    {
        if (new_theme != "light" && new_theme != "dark")
        {
            std::cerr << "ScrumDown: invalid theme configuration" << std::endl;
            return;
        }
        theme = new_theme;
    }

    Q_INVOKABLE int getTime() const noexcept
    {
        return time;
    }

    Q_INVOKABLE void setTime(const int new_time) noexcept
    {
        if (new_time < 0 || new_time > 5999)
        {
            std::cerr << "ScrumDown: invalid time configuration" << std::endl;
            return;
        }
        time = new_time;
    }

    Q_INVOKABLE bool getPinMode() const noexcept
    {
        return pin_mode;
    }

    Q_INVOKABLE void setPinMode(const bool new_pin_mode) noexcept
    {
        pin_mode = new_pin_mode;
    }

private:
    bool checkConfigsDir(const bool create_if_needed) const noexcept
    {
        const bool exist{QFile(configs_path).exists()};
        if (!exist)
        {
            std::cerr << "ScrumDown: configuration file not found" << std::endl;
            const auto configs_dir{configs_path.first(configs_path.lastIndexOf(QChar('/')))};
            if (!QDir(configs_dir).exists() && create_if_needed)
            {
                const bool created{QDir().mkdir(configs_dir)};
                if (!created)
                {
                    std::cerr << "ScrumDown: failed to create configurations directory" << std::endl;
                }
            }
            return create_if_needed && QDir(configs_dir).exists();
        }
        return exist;
    }

    QString stringifyConfigs() const noexcept
    {
        return QStringLiteral("%1,%2,%3,%4,%5,%6,%7,%8")
            .arg(maximized)
            .arg(geometry.x())
            .arg(geometry.y())
            .arg(geometry.width())
            .arg(geometry.height())
            .arg(theme)
            .arg(time)
            .arg(pin_mode);
    }

    void parseConfigs(const QStringList& values) noexcept
    {
        bool ok;
        if (const int maybe_maximized{values.at(0).toInt(&ok)}; ok)
        {
            maximized = static_cast<bool>(maybe_maximized);
        }
        if (const int maybe_x{values.at(1).toInt(&ok)}; ok)
        {
            geometry.setX(maybe_x);
        }
        if (const int maybe_y{values.at(2).toInt(&ok)}; ok)
        {
            geometry.setY(maybe_y);
        }
        if (const int maybe_width{values.at(3).toInt(&ok)}; ok)
        {
            geometry.setWidth(maybe_width);
        }
        if (const int maybe_height{values.at(4).toInt(&ok)}; ok)
        {
            geometry.setHeight(maybe_height);
        }
        setTheme(values.at(5));
        if(const int maybe_time{values.at(6).toInt(&ok)}; ok)
        {
            setTime(maybe_time);
        }
        if(const int maybe_pin{values.at(7).toInt(&ok)}; ok)
        {
            pin_mode = static_cast<bool>(maybe_pin);
        }
    }

private:
    QString configs_path;

    bool maximized;
    QRect geometry;
    QString theme;
    int time;
    bool pin_mode;
};

#endif // SCRUMDOWN_CONFIGS_MANAGER_H
