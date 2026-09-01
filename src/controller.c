#include "controller.h"
#include "sensor.h"

int controller_is_hot(void)
{
    return sensor_read() > 50;
}
