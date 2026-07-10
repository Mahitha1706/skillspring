public class VehicleFactory {

    public static Vehicle getVehicle(String type) {

        if (type.equalsIgnoreCase("car")) {
            return new Car();
        }

        if (type.equalsIgnoreCase("bike")) {
            return new Bike();
        }

        return null;
    }
}