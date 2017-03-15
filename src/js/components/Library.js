import React, { Component } from 'react';
import { View, Modal, Text, TouchableHighlight, StyleSheet } from 'react-native';

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
      <View style={styles.container}>
        <TouchableHighlight
          style={styles.openModalButton}
          onPress={this.openModalOnPress}
          onPressIn={this.openModalOnPressIn}
          onPressOut={this.openModalOnPressOut}
        >
          <Text style={styles.buttonText}>+</Text>
        </TouchableHighlight>

        <Modal
          animationType="slide"
          transparent={false}
          visible={this.state.isModalOpen}
          onRequestClose={this.modalOnRequestClose}
        >
          <View style={styles.container}>
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
  container: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    justifyContent: 'flex-end',
    alignItems: 'center',
    marginBottom: 22,
  },
  openModalButton: {
    justifyContent: 'center',
    alignItems: 'center',
    width: 60,
    height: 60,
    marginBottom: 40,
    borderRadius: 50,
    overflow: "hidden",
    backgroundColor: "#FFFFFF",
    borderColor: "#0099FF",
    borderWidth: 3,
  },
  buttonText: {
    fontSize: 40,
    justifyContent: 'center',
    alignItems: 'center',
    fontWeight: '300',
    color: "#0099FF",
  }
});

export default Library;
