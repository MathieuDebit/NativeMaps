import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  Button,
  View
} from 'react-native';
import Maps from './Maps';
import User from './User';
import Record from './Record';
import Library from './Library';
import AudioWrapper from './AudioWrapper';

export default class HomeScreen extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text>yo</Text>

        <Button
          style={styles.button}
          onPress={this.props.startMap}
          title="démarrer l'expérience"
        />
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
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
  },
});
