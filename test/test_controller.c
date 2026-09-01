#include "unity.h"

#include "controller.h"
#include "mock_sensor.h"

void setUp(void)
{
    mock_sensor_Init();
}

void tearDown(void)
{
    mock_sensor_Verify();
    mock_sensor_Destroy();
}

void test_controller_is_hot_when_sensor_above_50(void)
{
    sensor_read_ExpectAndReturn(60);

    TEST_ASSERT_TRUE(controller_is_hot());
}

void test_controller_is_not_hot_when_sensor_at_or_below_50(void)
{
    sensor_read_ExpectAndReturn(50);

    TEST_ASSERT_FALSE(controller_is_hot());
}

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_controller_is_hot_when_sensor_above_50);
    RUN_TEST(test_controller_is_not_hot_when_sensor_at_or_below_50);

    return UNITY_END();
}
