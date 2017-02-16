import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View, StyleSheet } from 'react-native';

class Library extends Component {

  state = {
    modalVisible: false,
    isPressed: false
  }

  setModalVisible(visible) {
    this.setState({modalVisible: visible});
  }

  render() {
    return (
      <View style={{marginTop: 22}}>
        <Modal
          animationType={"slide"}
          transparent={false}
          visible={this.state.modalVisible}
          onRequestClose={() => {alert("Modal has been closed.")}}
          >
         <View style={{marginTop: 22}}>
          <View>
            <Text>Hello World!</Text>

            <TouchableHighlight onPress={() => {
              this.setModalVisible(!this.state.modalVisible)
              this.setState({ isPressed: true })
            }}>
              <Text>Hide Modal</Text>
            </TouchableHighlight>

          </View>
         </View>
        </Modal>

        <TouchableHighlight
        style={ this.state.isPressed ? styles.showModalPressed : styles.showModal }
        onPress={() => {
          
        }}
        onPressIn={() => {
          this.setState({ isPressed: true })
          this.setModalVisible(true)
        }}
        onPressOut={() => {
          this.setState({ isPressed: false })
        }}
        >
          <Text></Text>
        </TouchableHighlight>

      </View>
    );
  }
}

const styles = StyleSheet.create({
  showModal: {
    backgroundColor: "#f1c40f",
    width: 40,
    height: 40,
    borderRadius: 50,
    borderWidth: 2,
    borderColor: '#f39c12',
    overflow: 'hidden',
    marginBottom: 20
  },
  showModalPressed: {
    backgroundColor: "#f39c12",
    borderColor: '#f1c40f',
    width: 45,
    height: 45
  }
});


export default Library;