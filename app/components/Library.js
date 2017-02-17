import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View, StyleSheet } from 'react-native';

class Library extends Component {
  constructor(props) {
    super(props);

    this.state = {
      isModalOpen: false,
      isPressed: false
    }

    this.openModalOnPress = this.openModalOnPress.bind(this);
    this.openModalOnPressIn = this.openModalOnPressIn.bind(this);
    this.openModalOnPressOut = this.openModalOnPressOut.bind(this);
    this.closeModalOnPress = this.closeModalOnPress.bind(this);
  }

  openModalOnPress() {

  }

  openModalOnPressIn() {
    this.setState({ isPressed: true, isModalOpen: true })
  }

  openModalOnPressOut() {
    this.setState({ isPressed: false })
  }

  modalOnRequestClose() {
    alert("Modal has been closed.");
  }

  closeModalOnPress() {
    this.setState({ isPressed: true, isModalOpen: false })
  }

  render() {
    return (
      <View style={styles.modalView}>
        <TouchableHighlight
          style={[
            styles.openModalButton,
            this.state.isPressed ? styles.openModalButtonPressed : styles.openModalButton
          ]}
          onPress={this.openModalOnPress}
          onPressIn={this.openModalOnPressIn}
          onPressOut={this.openModalOnPressOut}
        >
          <Text></Text>
        </TouchableHighlight>

        <Modal
          animationType="slide"
          transparent={false}
          visible={this.state.isModalOpen}
          onRequestClose={this.modalOnRequestClose}
        >
          <View style={styles.modalView}>
            <Text>Library</Text>

            <TouchableHighlight onPress={this.closeModalOnPress}>
              <Text>Hide Modal</Text>
            </TouchableHighlight>
          </View>
        </Modal>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  modalView: {
    marginTop: 22
  },
  openModalButton: {
    width: 40,
    height: 40,
    marginBottom: 20,
    borderRadius: 50,
    overflow: "hidden",
    backgroundColor: "orange",
  },
  openModalButtonPressed: {
    backgroundColor: "tomato",
  }
});


export default Library;
