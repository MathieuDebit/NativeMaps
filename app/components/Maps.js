import React, { Component } from 'react';
import { StyleSheet } from 'react-native';
import MapView from 'react-native-maps';
import mapStyle from './mapStyle.json';

class Maps extends Component {
  state = {
    initialPosition: null,
    lastPosition: null,
  };

  watchID: ?number = null;

  componentDidMount() {
    navigator.geolocation.getCurrentPosition(
      (position) => this.setState({ initialPosition: position }),
      (error) => alert(JSON.stringify(error)),
      {enableHighAccuracy: true, timeout: 20000, maximumAge: 1000}
    );

    this.watchID = navigator.geolocation.watchPosition((position) =>
      this.setState({ lastPosition: position })
    );
  }

  componentWillUnmount() {
    navigator.geolocation.clearWatch(this.watchID);
  }

  render() {
    if (this.state.lastPosition) {
      return (
        <MapView
          provider={MapView.PROVIDER_GOOGLE}
          style={styles.map}
          customMapStyle={mapStyle}
          region={{
            latitude: this.state.lastPosition.coords.latitude,
            longitude: this.state.lastPosition.coords.longitude,
            latitudeDelta: 0.00900,
            longitudeDelta: 0.00800,
          }}
        >
          <MapView.Marker
            coordinate={{
              latitude: this.state.lastPosition.coords.latitude,
              longitude: this.state.lastPosition.coords.longitude,
            }}
          />
        </MapView>
      )
    } else {
      return null;
    }
  }
}

const styles = StyleSheet.create({
  map: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
});

export default Maps;
