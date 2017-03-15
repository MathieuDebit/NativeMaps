import React, { Component } from 'react';
import { View, Text, StyleSheet } from 'react-native';

class User extends Component {
  constructor(props) {
    super(props);

    this.state = {
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <View style={styles.userAura} />
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
    justifyContent: 'center',
    alignItems: 'center',
  },
  userAura: {
    width: 300,
    height: 300,
    borderRadius: 500,
    borderWidth: 3,
    borderColor: "#0099FF",
  }
});

export default User;
