public class Main {

    public static void main(String[] args) {

        Vehicle v1 = VehicleFactory.getVehicle("car");
        v1.start();

        Vehicle v2 = VehicleFactory.getVehicle("bike");
        v2.start();
    }
}