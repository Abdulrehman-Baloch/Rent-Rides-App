
package application.renter;

import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import model.reservation.Feedback;
import model.reservation.Reservation;
import model.user.User;
import model.vehicle.Vehicle;

import java.sql.SQLException;

public class GiveFeedbackController {
    @FXML
    private ChoiceBox<Integer> driverRatingChoiceBox;
    @FXML
    private ChoiceBox<Integer> serviceRatingChoiceBox;
    @FXML
    private ChoiceBox<Integer> vehicleConditionRatingChoiceBox;
    @FXML
    private ChoiceBox<Integer> overallExperienceRatingChoiceBox;
    @FXML
    private TextArea commentsArea;
    @FXML
    private Label messageLabel;
    @FXML
    private Button submitButton;

    private int feedbackID;
    private int reservationID;
    private int renterID;
    private int vehicleID;
    private int driverID;
    private User user;
    private Reservation reservation;
    private Vehicle veh;

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public void setSelectedRenter(User user) {
        this.user = user;
    }

    public void setVehicle(Vehicle v) {
        this.veh = v;
    }

    @FXML
    private void initialize() {
        for (int i = 1; i <= 5; i++) {
            driverRatingChoiceBox.getItems().add(i);
            serviceRatingChoiceBox.getItems().add(i);
            vehicleConditionRatingChoiceBox.getItems().add(i);
            overallExperienceRatingChoiceBox.getItems().add(i);
        }
        showInitialAlert();
        
        Platform.runLater(() -> {
            Stage currentStage = (Stage) submitButton.getScene().getWindow();
            currentStage.setOnCloseRequest(event -> {
                if (isFeedbackEmpty()) {
                    return; 
                } else {
                    event.consume(); 
                    handleWindowCloseEvent(currentStage); 
                }
            });
        });
       }

    public void setFeedbackDetailsFromReservation(int feedbackID, int reservationID, int renterID, int vehicleID, int driverID) {
        this.feedbackID = feedbackID;
        this.reservationID = reservationID;
        this.renterID = renterID;
        this.vehicleID = vehicleID;
        this.driverID = driverID;
    }

    @FXML
    private void submitFeedback() throws SQLException {
        Integer driverRating = driverRatingChoiceBox.getValue();
        Integer serviceRating = serviceRatingChoiceBox.getValue();
        Integer vehicleConditionRating = vehicleConditionRatingChoiceBox.getValue();
        Integer overallExperienceRating = overallExperienceRatingChoiceBox.getValue();
        String comments = commentsArea.getText().trim();

        if (driverRating == null || serviceRating == null || vehicleConditionRating == null || overallExperienceRating == null) {
            messageLabel.setText("Error: All ratings must be selected.");
            messageLabel.setTextFill(Color.RED);
            return;
        }

        reservationID = reservation.getReservationID();
        renterID = user.getUserID();
        vehicleID = reservation.getVehicleID();
        driverID = reservation.getDriverID();

        Feedback feedback = new Feedback(feedbackID, reservationID, renterID, vehicleID, driverID,
                driverRating, serviceRating, vehicleConditionRating, overallExperienceRating, comments);

        boolean isSaved = feedback.saveFeedback(reservationID, renterID, vehicleID, driverID,
                driverRating, serviceRating, vehicleConditionRating,
                overallExperienceRating, comments);

        if (isSaved) {
            messageLabel.setText("Feedback submitted successfully!");
            messageLabel.setTextFill(Color.GREEN);
            showAlert("Feedback Submitted", "Feedback Submitted Successfully!");
            clearFields();
            closeScreen();
        } else {
            messageLabel.setText("Error: Failed to save feedback.");
            messageLabel.setTextFill(Color.RED);
        }
    }

    private void showInitialAlert() {
        Alert initialAlert = new Alert(AlertType.INFORMATION);
        initialAlert.setTitle("We'd love your feedback!");
        initialAlert.setHeaderText(null);
        initialAlert.setContentText("Please take a moment to share your experience.");
        initialAlert.showAndWait();
    }

    private void handleWindowCloseEvent(Stage stage) {
        Alert confirmAlert = new Alert(AlertType.CONFIRMATION);
        confirmAlert.setTitle("Feedback Confirmation");
        confirmAlert.setHeaderText("You have not submitted your feedback.");
        confirmAlert.setContentText("Do you want to continue giving feedback?");
        ButtonType yesButton = new ButtonType("Yes");
        ButtonType noButton = new ButtonType("No");

        confirmAlert.getButtonTypes().setAll(yesButton, noButton);
        confirmAlert.showAndWait().ifPresent(response -> {
            if (response == noButton) {
                stage.close(); // Close the window
            }
        });
    }

    @FXML
    private void configureCloseEvent() {
        Stage currentStage = (Stage) submitButton.getScene().getWindow();
        currentStage.setOnCloseRequest(event -> {
            if (isFeedbackEmpty()) {
                event.consume(); 
                handleWindowCloseEvent(currentStage); 
            }
        });
    }

    private boolean isFeedbackEmpty() {
        return driverRatingChoiceBox.getValue() == null &&
               serviceRatingChoiceBox.getValue() == null &&
               vehicleConditionRatingChoiceBox.getValue() == null &&
               overallExperienceRatingChoiceBox.getValue() == null &&
               commentsArea.getText().trim().isEmpty();
    }

    private void closeScreen() {
        Stage currentStage = (Stage) submitButton.getScene().getWindow();
        currentStage.close();
    }

    private void clearFields() {
        driverRatingChoiceBox.setValue(null);
        serviceRatingChoiceBox.setValue(null);
        vehicleConditionRatingChoiceBox.setValue(null);
        overallExperienceRatingChoiceBox.setValue(null);
        commentsArea.clear();
    }

    private void showAlert(String title, String message) {
        Alert alert = new Alert(AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
}
