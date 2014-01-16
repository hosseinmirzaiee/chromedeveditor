// Copyright (c) 2013, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/**
 * This class implements a cell to show a file.
 */

library spark.ui.widgets.fileitem_cell;

import 'dart:html';

import 'listview_cell.dart';
import '../../scm.dart' as scm;
import '../../workspace.dart';

class FileItemCell implements ListViewCell {
  Resource _resource;
  Element _element;
  bool _highlighted;
  bool acceptDrop;

  FileItemCell(this._resource) {
    DocumentFragment template =
        (querySelector('#fileview-filename-template') as TemplateElement).content;
    DocumentFragment templateClone = template.clone(true);
    _element = templateClone.querySelector('.fileview-filename-container');
    String name = _resource.name;
    if (_resource is Project) {
      if (scm.isUnderScm(_resource)) {
        // TODO: get branch name from the scm provider
        String branchName = '';
        String decoration = '[<i class="fa fa-code-fork"></i>${branchName}]';
        name = '${name} <span class="text-muted">${decoration}</span>';
      }
    }
    _element.querySelector('.filename').innerHtml = name;
    acceptDrop = false;
    updateFileStatus();
  }

  Element get element => _element;

  set element(Element element) => _element = element;

  bool get highlighted => _highlighted;

  set highlighted(bool value) => _highlighted = value;

  Element get fileStatusElement => _element.querySelector('.fileStatus');

  Element get gitStatusElement => _element.querySelector('.gitStatus');

  void updateFileStatus() {
    Element element = fileStatusElement;
    element.classes.removeAll(['warning', 'error']);

    int severity = _resource.findMaxProblemSeverity();

    if (severity == Marker.SEVERITY_ERROR) {
      element.classes.add('error');
    } else if (severity == Marker.SEVERITY_WARNING) {
      element.classes.add('warning');
    }
  }
}
